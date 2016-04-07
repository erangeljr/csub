%{
/* calc.l
 * borrowed from IBM
 */
 
#include <stdio.h>
#include "y.tab.h"

int c;
%}

%%
" "          ;                    /* skip spaces */
[a-z]        {
             c = yytext[0];       /* yytext is a string */
             yylval = c - 'a';    /* set yylval to ascii value */ 
             return(LETTER);
             }
[0-9]        {
             c = yytext[0];
             yylval = c - '0'; /* sets yylval to actual value of the digit */ 
             return(DIGIT);
             }
[^a-z0-9\b]  {
             c = yytext[0];
             return(c);
             }

