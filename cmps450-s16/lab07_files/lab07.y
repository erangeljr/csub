/* lab07.y                 
 * 450 lab07 
 * 
 * Goal: implement scope checking using a symbol table lookup
 * Note - this code does NO type checking - a NUMBER is a float or integer
 *
 *     $ make
 *     $ ./lab07 test.cf
 */

%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "symtab.h"

#define DEBUG 0
#define TRUE 1
#define FALSE 0
#define MAX_MSG_LEN 50
#define YYDEBUG 1

int errcnt = 0;
char errmsg[40];
extern char *yytext;
extern FILE *yyin;
extern FILE *yyout;
extern int yyparse();
extern int yylineno;
int yydebug = 1;
int t;
%}

/* no warning for fewer than 1 shift/reduce conflicts and 0 reduce/reduce */ 
%expect 1 

/* silence parser warning */
%name parser 

%union { int tokid;
         char *tokname;
       }

%token <tokname> IDENT  
%token <tokid> NUMBER ASSIGN PLUS LCURLY RCURLY LPAREN RPAREN SEMI ERROR 
%token <tokid> FLOAT INT 
%type <tokid> prog block decl_seq stmt_seq stmt decl expr term assignmnt 
%type <tokid> decltype error

%start prog 

%% 
prog        : decl_seq block
            ;
decl_seq    : /* nothing */  {}
            | decl_seq decl
            ; 
block       : LCURLY stmt_seq RCURLY  
            | error { yyerrok; return 0; } 
            ;

stmt_seq    : stmt_seq stmt SEMI
            | stmt SEMI
            | error  { yyerrok; return 0;} 
            ;

stmt        : expr  
            | assignmnt { $$ = $1; }
            | error  { yyerrok; return 0;} 
            ;

decl        : decltype IDENT SEMI { 
                setType($2,$1);
                fprintf(stdout,"set decltype to: %d for %s\n",$$,$2);  
            }
            ;
 
expr        : expr PLUS term 
 
            | term { $$ = $1; } 
            | error    { yyerrok; return 0;} 
            ;

assignmnt   : IDENT ASSIGN expr  { $$ = t = lookupType($1); } /*set break on t*/
            ;

term        : NUMBER { ; }

            | IDENT  { $$ = t = lookupType($1); }
            ;

decltype    : INT  { $$ = ITYPE; }
            | FLOAT { $$ = RTYPE; }
            ;

%%

int main( int argc,char *argv[] )
{
   strcpy(errmsg,"type error\n");
   int i;
   if(argc < 2) {
      printf("Usage: ./lab07 <source filename>\n");
      exit(0);
   }
   FILE *fp = fopen(argv[1],"r");
   if(!fp) {
     printf("Unable to open file for reading\n");
     exit(0);
   }
   yyin = fp;

   fp = fopen("dump.symtab","w");
   if(!fp) {
     printf("Unable to open file for writing\n");
     exit(0);
   }

   int flag = yyparse();
 
   /* dump symtab for debugging if necessary  */
   symtab_dump(fp);  
   printf("\nsemantic error cnt: %d \tlines of code: %d\n",errcnt,yylineno);

   /* cleanup */
   fclose(fp);
   fclose(yyin);

   return flag;
}


yywrap()
{
   return(1);
}

int yyerror(char * msg)
{ fprintf(stderr,"%s: line %d: \n",msg,yylineno);
  return 0;
}


