/* lab05.l     
 * Project: cmps 450 lab 5 
 */ 

%option yylineno

%{

#include <stdio.h>
#include <ctype.h>
#include <string.h>
#include "symtab.h"
#include "y.tab.h"
#include "lab05.h"

%}

comment         \/\/
digit           [0-9]
integer         {digit}+
real            {digit}+|{digit}+\.{digit}*
letter          [a-zA-Z]
identifier      ({letter}|_)+({digit}|{letter})*
charLiteral     \'({letter}|{digit})\'
newline         \n
whitespace      [ \t]+

%%

"int"           {  yylval = ITYPE;
                   return INT;
                }

"float"         { yylval = FTYPE;  
                  return FLOAT;
                }

"="             { return ASSIGN;}
"+"             { return PLUS;}

";"             { return SEMI; }
"{"             { return LCURLY; }
"("             { return LPAREN; }

"}"             { return RCURLY; }
")"             { return RPAREN; }

{integer}       {  yylval = ITYPE; 
                   return INTEGER; 
                }

{real}          { yylval = FTYPE; 
                  return REAL;
                }

{identifier}    { 
                  insert(yytext, 0, yylineno);
                  return IDENT;
                }

{whitespace}    { /* skip whitespace */}

{comment}       { /* skip C++ style comments */
                    char c;
                    do { 
                       c = input();
                    } while (c != '\n');
                }

.               { return ERROR;}

%%
