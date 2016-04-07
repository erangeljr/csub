/* file: calc.l 
 * Example 3-3. Lexer for AST calculator
 * recognize tokens for the calculator 
*/
%option noyywrap nodefault yylineno
%{
# include "calc.h"
# include "y.tab.h"
%}
/* float exponent */
EXP ([Ee][-+]?[0-9]+)
%%
"+"      |
"-"      |
"*"      |
"/"      |
"|"      |
"("      |
")"                     { return yytext[0]; }
[0-9]+"."[0-9]*{EXP}?  |
"."?[0-9]+{EXP}?        { yylval.d = atof(yytext); return NUMBER; }
\n                      { return EOL; }
"//".*
[ \t]                   { /* ignore whitespace */ }
.                       { yyerror("Mystery character %c\n", *yytext); }
%%
