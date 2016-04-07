/* grammarG.y                 
 * 450 ch04 dragon
 * 
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

%token IDENT PLUS TIMES LPAREN RPAREN ERROR 

%start expr 

%% 
expr        : expr PLUS term 
            | term
            ;
term        : term TIMES factor
            | factor 
            ; 
factor      : LPAREN expr RPAREN 
            | IDENT
            ;

%%

int main( int argc,char *argv[] )
{
   strcpy(errmsg,"type error\n");
   int i;
   if(argc < 2) {
      printf("Usage: ./grammarG <source filename>\n");
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


