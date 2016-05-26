%{
 /*  lab08.y
 *   a parser for an infix expression of form:
 *        (a + b) * (c - a)
 *   displays 3-address code for the expression
 *
 *   the attribute buckets hold the 3-address code 
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#define YYDEBUG 0
int tmp = 0;
%}

/* silence parser warning */
%name parser

%start list
%union {char *s;}
%token <s> A B C
%token LPAR RPAR PLUS MINUS MULT DIV NL
%type  <s>  expr term fact id

%% /* BNF Grammar for simple expressions */

list:   
    |
    list stmt NL
    ;
stmt: expr { printf("%s\n", "done."); free($1); $1 = NULL;}
    ;
expr: term  
        { 
        $$ = (char*)malloc(sizeof(char) * 1024);
        sprintf($$, "%s", $1);
        free($1);
        $1 = NULL;
        }
    | expr MINUS term  
        { 
        $$ = (char*)malloc(sizeof(char) * 1024);
        tmp++;
        printf("t%d = %s - %s\n", tmp, $1, $3);
        sprintf($$, "t%d", tmp);
        // sprintf($$, "minus(%s,%s)", $1, $3);
        free ($1);
        free ($3);
        $1 = NULL;
        $3 = NULL;
        }
    | expr PLUS term  
        { 
        $$ = (char*)malloc(sizeof(char) * 1024);
        tmp++;
        printf("t%d = %s + %s\n", tmp, $1, $3);
        sprintf($$, "t%d", tmp);
        //sprintf($$, "plus(%s,%s)", $1, $3); 
        free ($1);
        free ($3);
        $1 = NULL;
        $3 = NULL;
        }
    ;
term: fact
        { 
        $$ = (char*)malloc(sizeof(char) * 1024);
        sprintf($$, "%s", $1);
        free ($1);
        $1 = NULL;
        }
    | term MULT fact
        { 
        $$ = (char*)malloc(sizeof(char) * 1024);
        tmp++;
        printf("t%d = %s * %s\n", tmp, $1, $3);
        sprintf($$, "t%d", tmp);
       // sprintf($$, "times(%s,%s)", $1, $3); 
        }
    | term DIV fact 
        {
        $$ = (char*)malloc(sizeof(char) * 1024);
        tmp++;
        printf("t%d = %s / %s\n", tmp, $1, $3);
        sprintf($$, "t%d", tmp);
    //    sprintf($$, "divides(%s,%s)", $1, $3);
        }
    ;

fact:   id 
        { 
        $$ = (char*)malloc(sizeof(char) * 1024);
        sprintf($$, "%s", $1);
        free ($1);
        $1 = NULL;
        }

    | LPAR expr RPAR 
        { 
        $$ = (char*)malloc(sizeof(char) * 1024);
        //sprintf($$, "(%s)", $2);
        sprintf($$, "%s", $2);
        free ($2);
        $2 = NULL;
        }
    | MINUS fact   /* unary minus */
        {
        $$ = (char*)malloc(sizeof(char) * 1024);
        tmp++;
        printf("t%d = -%s\n", tmp, $2);
        sprintf($$, "t%d", tmp);
        // sprintf($$, "negative(%s)", $2);
        free ($2);
        $2 = NULL;
        }
    ;

id:  A | B | C 
    ;

%%

int yydebug = 0;
char *yytext;
FILE *yyin;
FILE *yyout;
int yyparse();
extern int tmp;  /* use this to construct a new TAC variable */

int main( int argc,char *argv[] )
{
   if(argc < 2) {
      printf("Usage: ./lab08 <input filename>\n");
      exit(0);
   }
   FILE *fp = fopen(argv[1],"r");
   if(!fp) {
     printf("Unable to open file for reading\n");
     exit(0);
   }
   yyin = fp;
   return (yyparse());
}


yyerror(sb)
char *sb;
{
  fprintf(stderr, "%s\n\n",sb);
}


yywrap()
{
  return(1);
}

