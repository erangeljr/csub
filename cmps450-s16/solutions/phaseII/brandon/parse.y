%{

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdbool.h>
#include <assert.h>
#include "symtab.h"

#define DEBUG 0
#define MAX_MSG_LEN 50
#define YYDEBUG 1

int errcnt = 0;
extern char *yytext;
extern FILE *yyin;
extern FILE *yyout;
extern int yyparse();
extern int line_cnt;
int yydebug = 1;
int t;

enum err_status {ERR_DISABLE, ERR_ENABLE};

bool is_declared(int);
int safe_cast(int, int, int);
int get_upcast_type(int, int);
%}

/* no warning for fewer than 1 shift/reduce conflicts and 0 reduce/reduce */ 
%expect 1 
%name parser /* silence compiler warning */
%union {int tokid; char *tokname;}

%token <tokname> IDENT CHAR_CONST STR_CONST UINT FP

%token <tokid> UNKNOWN UNDEFINED ERROR VOID CHAR INT FLOAT BREAK GOTO ELSE
%token <tokid> IF READ RETURN WHILE WRITE INCR DECR EQ NE LT GT GT_EQ LT_EQ AND
%token <tokid> OR LPAREN

/* these must be in upcast order */
%token <tokid> CTYPE /* <= */ ITYPE /* <= */ RTYPE 

%type <tokid> func param type decl assignment expr term factor 
%type <tokid> relop number ident stmt stmt_seq param_seq initializer

%start program 

%%

program         : decl_seq func
                ;

func            : type IDENT '(' param_seq ')' '{' stmt_seq RETURN expr ';' '}' {
                    setType($<tokname>2, $1);
                    safe_cast($1, $9, ERR_ENABLE);
                  }
                ;

param_seq       : /* empty */ {}
                | param_seq ',' param
                | param 
                ;

param           : type IDENT {setType($<tokname>2, $1);}
                ;

decl_seq        : /* empty */
                | decl_seq decl
                ;

block           : '{' stmt_seq '}'
                ;

stmt_seq        : stmt_seq stmt
                | stmt
                ;

stmt            : ident ';' {(void)is_declared($1);}
                | assignment
                | WHILE cond block
                | IF cond block ELSE block
                | ';' {}
                ;

decl            : type IDENT initializer ';' {setType($<tokname>2, $1);
                                              if($3 != UNDEFINED)
                                                  safe_cast($1, $3, ERR_ENABLE);
                                             }
                ;

initializer     : /* empty */  {$$ = UNDEFINED;}
                | '=' expr {$$ = $2;} 
                ;

type            : INT         {$$ = ITYPE;}
                | FLOAT       {$$ = RTYPE;}
                | CHAR_CONST  {$$ = CTYPE;}
                ;

assignment      : ident '=' expr ';' {if(is_declared($1))
                                          safe_cast($1, $3, ERR_ENABLE);
                                     }
                ;

expr            : expr '+' term {$$ = get_upcast_type($1, $3);}
                | term
                ;

term            : term '*' factor {$$ = get_upcast_type($1, $3);}
                | factor
                ;

factor          : '(' expr ')' {$$ = $<tokid>2;}
                | ident        {(void)is_declared($1);}
                | number
                ;

number          : UINT {setType($<tokname>1, ITYPE); $$ = ITYPE;}
                | FP   {setType($<tokname>1, RTYPE); $$ = RTYPE;}
                | CHAR {setType($<tokname>1, CTYPE); $$ = CTYPE;}
                ;

cond            : '(' expr ')'
                | '(' bool ')'
                ;

bool            : ident relop factor {(void)is_declared($1);}
                ;

relop           : EQ
                | NE
                | GT
                | LT
                | LT_EQ
                | GT_EQ
                ;

ident           : IDENT {$$ = lookupType($<tokname>1);}
                ;

%%

bool is_declared(int id)
{
    if (id == -1 || id == IDENT)
    {
        yyerror("ERROR: undeclared identifier");
        ++errcnt;
        return false;
    }
    return true;
}

int safe_cast(int dest_type, int src_type, int err_status)
{
    /* ignore undeclared identifiers; they're handeled elsewhere */
    if (dest_type == -1 || src_type == -1)
        return 0;

    if (dest_type >= src_type)
        return dest_type;
    if (err_status == ERR_ENABLE)
    {
        yyerror("ERROR: illegal implicit downcast");
        ++errcnt;
        return dest_type;
    }
    return 0;
}

int get_upcast_type(int type1, int type2)
{
    return safe_cast(type1, type2, ERR_DISABLE) ? type1 : type2;
}

int main( int argc,char *argv[] )
{
   FILE *fp;
   int flag;

   /* insure type values follow upcast order */
   assert(CTYPE < ITYPE && ITYPE < RTYPE);

   if(argc < 2) {
      printf("Usage: %s <source filename>\n", argv[0]);
      exit(1);
   }

   if (!strcmp(argv[1], "y.tab.c"))
   {
       printf("\nWARNING: the dream is collapsing\n");
       exit(1);
   }

   fp = fopen(argv[1],"r");
   if(!fp) {
     printf("Unable to open file %s for reading\n", argv[1]);
     exit(1);
   }
   yyin = fp;

   fp = fopen("dump.symtab","w");
   if(!fp) {
     printf("Unable to open file for writing\n");
     exit(1);
   }

   flag = yyparse();
 
   /* dump symtab for debugging if necessary  */
   symtab_dump(fp);  
   printf("\nsemantic error cnt: %d \tlines of code: %d\n",errcnt,line_cnt);

   /* cleanup */
   fclose(fp);
   fclose(yyin);

   return flag;
}

int yywrap()
{
    return(1);
}

int yyerror(char * msg)
{
    fprintf(stderr,"%s: line %d\n",msg,line_cnt+1);
    return 0;
}
