%{
/* calc.y 
 * reads and evaluates arithmetic expressions from stdin */

#include <stdio.h>

#define YYDEBUG 1    /*  set this flag if you want to trace execution */

void yyerror(char *);

int yydebug = 0;   /* 0=errors only; 1=reductions; 2=more... */
int symbols[26];
int base;

%}

%start list

%token DIGIT LETTER

/* control precedence and associativity of arithmetic operators 
 * precedence is low to high; e.g., * has precedence over + 
 */
%left '+' '-'
%left '*' '/' 
%left UMINUS  /*supplies precedence for unary minus */

%%                   /* beginning of rules section */

list:                       /*empty */
         |
        list stat '\n'
         |
        list error '\n'      { yyerrok; }
         ;

stat:    expr
         {
           printf("%d\n",$1);
         }
         |
         LETTER '=' expr
         {
           symbols[$1] = $3;
         }

         ;

expr:    '(' expr ')'
         {
           $$ = $2;
         }
         |
         expr '*' expr
         {

           $$ = $1 * $3;
         }
         |
         expr '/' expr
         {
           $$ = $1 / $3;
         }
         |
         expr '+' expr
         {
           $$ = $1 + $3;
         }
         |
         expr '-' expr
         {
           $$ = $1 - $3;
         }
         |

        '-' expr %prec UMINUS
         {
           $$ = -$2;
         }
         |
         LETTER
         {
           $$ = symbols[$1];
         }

         |
         number
         ;

number:  DIGIT
         {
           $$ = $1;
           base = ($1==0) ? 8 : 10;
         }       
         |
         number DIGIT
         {
           $$ = base * $1 + $2;
         }
         ;

%%
int main()
{
   yyparse();
   return 0;
}

void yyerror(char *s)
{
  fprintf(stderr, "%s\n",s);
}

yywrap()
{
  return(1);
}

