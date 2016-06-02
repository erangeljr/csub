/* parse.y                 
 * PHASE II SOLUTION - produces a compiler for Cflat
 */

%{

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "symtab.h"
#include "defs.h"

#define TRUE 1
#define FALSE 0
#define MAXTOKENLEN 40
#define MAX_MSG_LEN 50
#define YYDEBUG 1

char errmsg[40];
int pflag = 0;   /* flag to let scanner know that parameters are coming */
int scope = 0;   /* parser sets this when entering param list scope */
extern int yylineno;
extern char *yytext;
FILE *logfd;
extern FILE *yyin;
extern FILE *yyout;
extern int yyparse();
int yydebug = 1;

%}

/* no warning for fewer than 1 shift/reduce conflicts and 0 reduce/reduce */ 
%expect 1 

/* silence parser warning */
%name parser 

%union { 
   int toktype;
   char *name;
}

%token <name> IDENT ICONST FCONST CCONST SCONST 

%token <toktype> INT FLOAT CHAR
%token <toktype> RET WHILE IF ELSE
%token <toktype> LPAREN RPAREN SEMI COMMA LBRACK RBRACK LCURLY RCURLY
%token <toktype> ASSIGN EQ LT LE GE GT NE PLUS MINUS TIMES OVER PLUSEQ MINUSEQ 
%token <toktype> ERROR

%type <toktype> func program block decl_seq decl stmt stmt_seq expr term  error
%type <toktype> number type_spec bool_expr bool_op op assign_stmt 
%type <toktype> param_list param param_seq


%start program 

%left PLUS MINUS  
%left TIMES OVER 

%% 
program   : decl_seq func {;}  
          ;

decl_seq   :  /* nothing */ {;}
           | decl_seq decl
           ;

decl       : type_spec IDENT SEMI 
           {  setType ($2, $1); } 

           | type_spec IDENT ASSIGN expr SEMI 
           {   setType ($2, $1); 
               if ($1 != $4) 
             fprintf(logfd,"Type err type_spec assign_stmt,line %d\n",yylineno);
           } 
           ;

type_spec  : INT     {$$ = ITYPE;} 
           | FLOAT   {$$ = FTYPE; } 
           | CHAR    {$$ = CTYPE;}
           ;

func       : type_spec IDENT {scope++;} LPAREN {pflag++;}
                 param_list RPAREN {pflag--;}  
             LCURLY stmt_seq RET expr 
               { setType($3,$1); 
                 if ($1 != $13) 
                 fprintf(logfd,"Type err: return value, line %d\n",yylineno);
               }
              SEMI RCURLY            
           ;

param_list : /* nothing */  {;}
           | param_seq   {;}
           ;
 
param_seq  : param  { ;}
           | param COMMA param_seq 
           ; 

param      : type_spec IDENT    
           {  setType ($2, $1); } 

block      : LCURLY stmt_seq RCURLY   {;}
           | error { yyerrok; return 0; } 
           ;

 
stmt_seq   : /* nothing */ { ;} 
           | stmt_seq stmt   {;} 
           | error  { yyerrok; return 0;} 
           ;

stmt        : SEMI  { ; }
            | expr SEMI   {;}
            | assign_stmt  {;}
            | WHILE condition block      {;}
            | IF condition block ELSE block {;}
            | error                      {yyerrok; return 0;} 
            ;

assign_stmt : IDENT ASSIGN expr SEMI     
            { 
              /* check if rvalue has already violated type */
               if ($3 == -1) 
                 $$ = $3;
               else {
                 int t = lookupType($1); 
                 if (t != $3) 
                 fprintf(logfd,"Type err: assign_stmt, line %d\n",yylineno);
               }
            }
            ;

condition   : LPAREN bool_expr RPAREN  {;}
            ;

bool_expr   : term bool_op term       {;} 
            ;

bool_op     : EQ | LE | LT | GT | GE | NE
            ;

expr        : expr op term  
            { 
              if ($1 == $3) /* no type error */
                   $$ = $1; 
              else
                 if ($1 == -1) /* type error already found so trickle -1 up */
                     $$ = -1;
              else   /* we have an unreported type error */
              { 
                 $$ = -1;
                 fprintf(logfd,"Type err:exp->exp op term,line %d\n",yylineno);
              }
            }
            | term   { $$ = $1; } 
            | error  { yyerrok; return 0;} 
            ;


op:         TIMES | PLUS | MINUS | OVER
            ;

term        : number   {$$ = $1;}
            | IDENT    {$$ = lookupType($1); }
            | CCONST   {$$ = CTYPE; }
            ;
  
number      : ICONST { $$ = ITYPE; }
            | FCONST { $$ = FTYPE; }
            | error  { yyerrok; return 0;} 
            ;

%%


int main( int argc,char *argv[] )
{
   strcpy(errmsg,"type error\n");
   int i;
   if(argc < 2) {
      printf("Usage: cf <source filename>\n");
      exit(0);
   }
   FILE *fd = fopen(argv[1],"r");
   if (!fd) {
     printf("Unable to open file for reading\n");
     exit(0);
   }
   yyin = fd;

   logfd = fopen("log","w");
   if (!logfd) {
     printf("Unable to open log file for writing\n");
     exit(0);
   }


   fd = fopen("sym.dump","w");
   if (!fd) {
     printf("Unable to open file for writing\n");
     exit(0);
   }

   int flag = yyparse();
 
    /* dump symtab for debugging if necessary  */
    symtab_dump(fd);   

   /* cleanup */
   fclose(fd);
   fclose(logfd);
   fclose(yyin);

   return flag;
}


yywrap()
{
   return(1);
}

int yyerror(char * msg)
{ fprintf(logfd,"%s line %d.\n",msg,yylineno);
  return 0;
}
