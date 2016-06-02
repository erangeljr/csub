/* sample.y
 * demonstrate constructing simple parser and scanner
 */

%{    
#include <stdio.h>
#include <math.h>
#define YY_parse_PARSE yyparse
#define YYDEBUG 1

int yydebug = 1; /* 0=errors only; 1=error and reductions; 2=more ... */
extern int yylineno;
void yyerror(char *s);
%} 

%start program  

%token IDENT NUMBER ERROR
 
%% 
  
program: list 
         | 
        error '\n'    { yyerrok; } /* error is a pseudo-token
                                    * the action is to call 
                                    * error procedure 
                                    */
         ;
list:    /* nothing */
         | 
        list IDENT      {; }
         | 
        list NUMBER     {; }
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

