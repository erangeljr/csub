%{
 /* lab07.l     
  * Project: cmps 450 lab 7 - implement scope checking 
  */ 

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

int hashaddress;      /* holds the address into the hash table */
%}

%option yylineno

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

"int"           { return INT; }
"float"         { return FLOAT; }
"="             { return ASSIGN;}
"+"             { return PLUS;}
";"             { return SEMI; }
"{"             { return LCURLY; }
"("             { return LPAREN; }
"}"             { return RCURLY; }
")"             { return RPAREN; }

{integer}       { return NUMBER; }

{real}          { return NUMBER; }

{identifier}    { /* the first time the scanner encounters an identifier it
                   * inserts -1 as the type - the parser will set type but 
                   * the -1 lets the parser know that this is the first 
                   * encounter with this identifier */
 

                  yylval.tokname = malloc(sizeof(yytext));
                  strncpy(yylval.tokname,yytext,yyleng);
                  insert(yytext, yyleng, -1, yylineno);
                  return IDENT;
                }

{newline}       {;}

{whitespace}    { /* skip whitespace */}

{comment}       { /* skip C++ style comments */
                    char c;
                    do { 
                       c = input();
                    } while (c != '\n');
                }

.               { return ERROR;}

%%
