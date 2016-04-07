/* lab06.y                 
 * 450 lab06 
 * 
 * modify this file to implement type checking by symbol table lookup
 *
 *     $ make
 *     $ ./lab06 good.cf
 */

%{

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "symtab.h"
#include "lab06.h"

FILE *logfd;

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

%union { 
   int toktype;
   char *name;
}

%token <name> IDENT INTEGER REALNUM 
%token <toktype> FLOAT INT LCURLY RCURLY SEMI PLUS ASSIGN LPAREN RPAREN ERROR
%type <toktype> block stmt_seq stmt decl expr term assignmnt decltype number error

%start block

%% 

block       : LCURLY stmt_seq RCURLY  
            | error { yyerrok; return 0; } 
            ;

stmt_seq    : stmt_seq stmt SEMI
            | stmt SEMI
            | error  { yyerrok; return 0;} 
            ;

stmt        : expr    {;}
            | decl     { ; } 
            | assignmnt { ; }
            | error  { yyerrok; return 0;} 
            ;

decl        : decltype IDENT { 
                setType($2,$1);
                if (DEBUG) fprintf(logfd,"set decltype to: %d for %s\n",$$,$2); 
            }
            ;
 
expr        : expr PLUS term { ; }
 
            | term { ; } 
            | error    { yyerrok; return 0;} 
            ;

assignmnt   : IDENT ASSIGN expr  { ; }
            ;

term        : number { ; }

            | IDENT  { $$ = lookupType($1); }
            ;

decltype    : INT  { $$ = ITYPE; }
            | FLOAT { $$ = FTYPE; }
            ;

number      : INTEGER { $$ = ITYPE; }
            | REALNUM { $$ = FTYPE; }

%%

int main( int argc,char *argv[] )
{
   strcpy(errmsg,"type error\n");
   int i;
   if(argc < 2) {
      printf("Usage: ./cfc <source filename>\n");
      exit(0);
   }
   FILE *fd = fopen(argv[1],"r");
   if(!fd) {
     printf("Unable to open file for reading\n");
     exit(0);
   }
   yyin = fd;

   fd = fopen("dump.symtab","w");
   if(!fd) {
     printf("Unable to open file for writing\n");
     close(yyin);
     exit(0);
   }

   logfd = fopen("log","w");
   if(!logfd) {
     printf("Unable to open log file for writing\n");
     close(yyin);
     close(fd);
     exit(0);
   }

   int flag = yyparse();
 
   /* dump symtab for debugging if necessary  */
   symtab_dump(fd);  
   fprintf(logfd,"\nsemantic error cnt: %d \n",errcnt);

   /* cleanup */
   fclose(fd);
   fclose(yyin);
   fclose(logfd);

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


