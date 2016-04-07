%{
/* sdt.l
 * demonstrate how to implement semantic type checking for simple addition 
 * expressions; we use the token type (INTEGER or REAL) to distinguish type
 * in the parser. Since token type is an integer we do not need a union to
 * hold an attribute value.
*/
 
#include <stdio.h>
#include <string.h>
#include "y.tab.h"

#define MAXTOKENLEN 40
char tokenString[MAXTOKENLEN+1];
char c;
int line_no = 1;
int col_no = 1;

%}

%option yylineno
%array

digit       [0-9]
integer     {digit}+
real        {integer}+\.{integer}+
newline     \n

%%
" "       ;

{integer}    { strncpy(tokenString,yytext,yyleng);
               col_no+= yyleng;
               return(INTEGER);
             }

{real}       { strncpy(tokenString,yytext,yyleng);
               col_no+= yyleng;
               return(REAL);
             }

{newline}    { line_no++; col_no = 1; 
               c = yytext[0];
               return (c); }

[^a-z0-9\b]  { c = yytext[0];
               col_no++;
               return(c);
             }

