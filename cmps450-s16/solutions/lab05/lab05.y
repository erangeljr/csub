/* lab05.y                 
 * 450 lab05
 * 
 * Goal: implement a BNF Grammar for type checking assignment statements 
 *
 *     $ make
 *     $ ./lab05 bad.cf
 */

%{

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "symtab.h"
#include "lab05.h"

#define DEBUG 0
#define MAXTOKENLEN 40
#define MAX_MSG_LEN 50

FILE *logfd;
FILE *infd;
FILE *symfd;
int errcnt = 0;
extern int yylineno;
char errmsg[40];
%}

/* no warning for fewer than 1 shift/reduce conflicts and 0 reduce/reduce */ 
%expect 1  

/* silence parser warning */
%name parser 

%token INT FLOAT IDENT INTEGER REAL  
%token ASSIGN PLUS LCURLY RCURLY LPAREN RPAREN SEMI
%token ERROR

%start block

%% 

block       : LCURLY stmt_seq RCURLY   
            | error { yyerrok; return 0; } 
            ;

stmt_seq    : stmt_seq stmt SEMI
            | stmt SEMI
            | error  { yyerrok; return 0;} 
            ;

stmt        : expr
            | decl 
            | assignmnt { $$ = $1; }
            | error  { yyerrok; return 0;} 
            ;

decl        : type IDENT 
              {$$ = $1;  
               $2 = $1;
              if (DEBUG) 
                fprintf(stderr,"ndecl: %d TYPE: %d IDENT: %d\n",$$,$1,$2);
              }

            | type assignmnt 
              { if ($1 != $2) 
                  {
                    errcnt++;
                    fprintf(logfd,"Type Error line %d\n",yylineno); 
                  }
              }
            ;

type        : INT     { $$ = ITYPE; }
            | FLOAT   { $$ = FTYPE; }
            ;
 
expr        : expr PLUS term  
              { if ($1 != $3)  {
                    errcnt++;
                    fprintf(logfd,"Type Error line %d\n",yylineno); 
                 }
              }
 
            | term   { $$ = $1; }
            
            | error  { yyerrok; return 0;} 
            ;

term        : number   { $$ = $1; }
            | IDENT    { $$ = $1; }
            ;

assignmnt   : IDENT ASSIGN expr  { 
                if ($1 != $3) {
                    errcnt++;
                    fprintf(logfd,"Type Error line %d\n",yylineno); 
                } 

                $$ = $1;
                }
            ;

number      : INTEGER  { $$ = ITYPE; }
            | REAL     { $$ = FTYPE; }
            | error  { yyerrok; return 0;} 
            ;

%%

extern char *yytext;
extern FILE *yyin;
extern FILE *yyout;
extern int yyparse();

int yydebug = 1;
extern int yylineno;

int main( int argc,char *argv[] )
{
   strcpy(errmsg,"type error\n");
   int i;
   if(argc < 2) {
      printf("Usage: lab05 <source filename>\n");
      exit(0);
   }
   infd = fopen(argv[1],"r");
   if(!infd) {
     printf("Unable to open file for reading\n");
     exit(0);
   }
   yyin = infd;

   logfd = fopen("log","w");
   if(!logfd) {
     printf("Unable to open log file for writing\n");
     exit(0);
   }

   int flag = yyparse();
 
   /* dump symtab for debugging if necessary  */
   symfd = fopen("symtab.dump","w");
   symtab_dump(symfd);   

   printf("\nSemantic error count: %d\n",errcnt);
   /* cleanup */
   fclose(logfd);
   fclose(symfd);
   fclose(yyin);

   return flag;
}


yywrap()
{
   return(1);
}

int yyerror(char * msg)
{ fprintf(stderr,"%s line %d: \n",msg,yylineno);
  return 0;
}


