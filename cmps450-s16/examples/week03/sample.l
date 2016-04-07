%{
/* sample.l
 * demonstrate use of union for yylval 
 * accepts things like this:
 * a = 4 + 2
 */

#include <stdlib.h>
#include <string.h>

#include "y.tab.h"
%}

%%

[\t \n]+          /* ignore */ ;

\+ |
\- |
\* |
\/              { yylval.op_val = yytext[0]; return OP; };

[a-zA-Z]+       { yylval.str_val = strdup( yytext ); return NAME; };

[0-9]+          { yylval.int_val = atoi( yytext ); return NUMBER; };

\=              { yylval.op_val = '='; return ASSIGN;} ;

%%

