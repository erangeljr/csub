%{
/*  dec-to-hex.l
 *  A lex input file that:
 *  changes all numbers to hexadecimal from stdin
 *  ignores all others 
 */

#include <stdio.h>
%}

digit   [0-9]
number  {digit}+

%%
{number}     {  int n = atoi(yytext);
                printf("%x", n); 
             }
.            {;}
%%

int main()
{
  yylex(); return 0;
}

