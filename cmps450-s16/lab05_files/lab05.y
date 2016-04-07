/* lab05.y                 
 * Implements a BNF Grammar for blocks and * and + expressions
 * Modify to enforce strong typing 
 *
 * The pseudo-token error calls the default error routine yyerrok - if you
 * cannot recover from parsing you should immediately exit 
 *
 * Shift/reduce conflicts means your grammar is ambiguous or would require more
 * than one lookahead symbol to resolve the conflict. Bison resolves this 
 * conflict by doing the shift. A reduce/reduce conflict occurs because two or 
 * more rules match the same string of tokens. Bison resolves this conflict by 
 * reducing the rule that occurs earlier in the grammar. These warnings are not
 * necessarily bad but pay attention and check your grammar for problems. 
 * 
 *  $ make
 *  $ ./cf good.cf
 */

%{

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "symtab.h"

#define TRUE 1
#define FALSE 0
#define MAXTOKENLEN 40
#define MAX_MSG_LEN 50
#define YYDEBUG 1

extern char *yytext;
extern FILE *yyin;
extern FILE *yyout;
extern int yyparse();
FILE *symfd;
FILE *logfd;
FILE *infd;
int yydebug = 1;
extern int yylineno;

%}

/* no warning for fewer than 1 shift/reduce conflicts and 0 reduce/reduce */ 
%expect 1 

/* silence parser warning */
%name parser 

%token IDENT REAL INTEGER  
%token ASSIGN PLUS LCURLY RCURLY SEMI ERROR

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
            | assignmnt 
            { $$ = $1; 
              fprintf(logfd,"evaluating stmt->exp at line %d\n",yylineno);

            }
            | error  { yyerrok; return 0;} 
            ;

expr        : expr PLUS term  { ; }
 
            | term 
            | error  { yyerrok; return 0;} 
            ;

term        : number
            | IDENT
            ;

assignmnt   : IDENT ASSIGN expr
            ;

number      : INTEGER  { ; }
            | REAL     { ; }
            | error  { yyerrok; return 0;} 
            ;

%%


int main( int argc,char *argv[] )
{
   int i;
   if(argc < 2) {
      printf("Usage: lab05 <filename>\n");
      exit(0);
   }
   infd = fopen(argv[1],"r");
   if(!infd) {
      printf("Unable to open file for reading\n");
      exit(0);
   }
   /* redirect stdin to infile */
   yyin = infd;

   /* open this in case you want to spit out your own diagnostics */
   logfd = fopen("log","w");
   if(!logfd) {
     printf("Unable to open log file for writing\n");
     exit(0);
   }

   int flag = yyparse();

   /* open a file to dump the symbol table to */ 
   symfd = fopen("symtab.dump","w");
   symtab_dump(symfd);   

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

