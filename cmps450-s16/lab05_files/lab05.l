/* lab05.l     
 * Project: cmps 450 lab 5 
 * implement SDT for strong typing
 */ 

%option yylineno

%{
#include <stdio.h>
#include <ctype.h>
#include <string.h>
#include "symtab.h"
#include "y.tab.h"

#ifndef TRUE
#define TRUE 1 
#endif

#ifndef FALSE 
#define FALSE 0 
#endif

%}


digit           [0-9]
integer         {digit}+
real            {digit}+|{digit}+\.{digit}*
letter          [a-zA-Z]
identifier      ({letter}|_)+({digit}|{letter})*
charLiteral     \'({letter}|{digit})\'
newline         \n
whitespace      [ \t]+

%%

"="             { return ASSIGN;}
"+"             { return PLUS;}

";"             { return SEMI; }
"{"             { return LCURLY; }
"}"             { return RCURLY; }

{integer}       { return INTEGER; }

{real}          { return REAL; }

{identifier}    { 
                  insert(yytext, 0, yylineno);
                  return IDENT;
                }

{newline}       { ; }

{whitespace}    { /* skip whitespace */}

.               { return ERROR;}

%%
