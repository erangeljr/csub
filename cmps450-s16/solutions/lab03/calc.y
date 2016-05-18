/* calc.y  
 * cmps 450 lab03 SOLUTION - calculator for integers and floating point numbers
 *  
 * This parser grabs a token from the scanner, verifies syntax, stores value, 
 * displays final computation, repeats until EOF .
 *
 * Expressions are evaluated by during parsing by synthesized attributes.
 * 
 *   $ make
 *   $ cat input | ./calc
 *
 * Sample input (expression end is marked by newline):
 * 
 *  (0.5 + 2.5) * 2.1
 *  7.3 * 5 
 *  2 + 2
 *  a = 4
 *  b = 6
 *  a + b
 *
 *  Output:
 *  6.30
 *  36.50
 *  4.00
 *  10.00
 *
 */


%{     /* start of C definition section */

#include <stdio.h>
#include <math.h>
#define YY_parse_PARSE yyparse

double symbols[26];
int base = 10;
int lineno = 1;
extern int yylineno;

void yyerror(char *s);

%}    /* end of C-code definitions section */

%start list    /* you can specify starting symbol for the grammar */

  /*  %union redefines yylval from default type int to a union; The yylval 
   *  of the token is not the token number (or token id). The token id is
   * returned by lex as an integer */

%union {
   double fval;   /* float value */
   int dval;      /* decimal value */
   char a_z;
}    
                                    
%token <a_z> LETTER    /* set yylval type for terminals in the grammar */
%token <dval> INTEGER   /* decimal value */
%token <fval> FLOAT     /* float value */

%type <fval> expr number  

%left '+' '-'        /* set left associativity for + and - operators */
%left '*' '/' '%'    /* left associates but higher precedence than + and -  */
%left UMINUS         /* UMINUS has precedence over preceding four operators */

%%                   /* end of declarations - beginning of rules section */
  
list:                 /* empty */
         |
        list stmt'\n'      { lineno++; }
         |
        list error '\n'    { yyerrok; lineno++; } /* error is a pseudo-token
                                                   * the action is to call 
                                                   * error procedure 
                                                   */
         ;

stmt:    expr               { printf("%5.2f\n",$1);  }
         |
         LETTER '=' expr    { symbols[$1] = $3; }  /* store value in symbols */
         ;

expr:    '(' expr ')'        { $$ = $2; }   /* $$ is expr on LHS; $2 is expr 
                                                on LHS; this is synthesis */
         |
         expr '*' expr       { $$ = $1 * $3; } /* perform operation on the
                                                * attribute values; synthesize 
                                                * result up tree 
                                                */
         |
         expr '/' expr        { $$ = $1 / $3; }   /* perform operation */
         |
         expr '+' expr        { $$ = $1 + $3; }   /* perform operation */
         |
         expr '-' expr        { $$ = $1 - $3; }   /* perform operation */
         |

        '-' expr %prec UMINUS { $$ = -$2; }        /* give UMINUS precedence*/
         |
       LETTER              { $$ = symbols[$1]; }  /* load value from symtable */
         |
       number              
         ;

number:  INTEGER             { $$ = $1; }   
         |
         FLOAT               { $$ = $1; }
         ;

%%         /* end of rules section */
 
main()
{
  return(yyparse());
}

void yyerror(char *s)
{
  fprintf(stderr, "%s, lineno %d\n",s, yylineno);
}

yywrap()
{
  return(1);
}
