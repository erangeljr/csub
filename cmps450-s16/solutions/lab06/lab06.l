/*  lab06.l     
 *  cmps 450 lab 6
 *  modify this code to implement type checking by symbol table lookup 
 */ 

%option yylineno

%{

#include <stdio.h>
#include <ctype.h>
#include <string.h>
#include "symtab.h"
#include "y.tab.h"
#include "lab06.h"
extern FILE *logfd;

%}

comment         \/\/
digit           [0-9]
integer         {digit}+
real            {digit}+|{digit}+\.{digit}*
letter          [a-zA-Z]
identifier      ({letter}|_)+({digit}|{letter})*
charLiteral     \'({letter}|{digit})\'
whitespace      [ \t\n]+

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

{integer}       { /* copy yytext to attribute bucket - let parser do atoi */
                  yylval.name = malloc(sizeof(yytext));
                  strncpy(yylval.name,yytext,yyleng);
                  return INTEGER; 
                }

{real}          { /* copy yytext into attribute bucket - parser will do atof */
                  yylval.name = malloc(sizeof(yytext));
                  strncpy(yylval.name,yytext,yyleng);
                  return REALNUM;
                }

{identifier}    { /* insert identifier into symbol table and copy yytext into
                   * attribute bucket - parser needs yytext to do symbol table
                   * lookup 
                   */  

                  yylval.name = malloc(sizeof(yytext));
                  strncpy(yylval.name,yytext,yyleng);
                  if (DEBUG) fprintf(logfd,"id yylval: %s ",yylval.name);
                  insert(yytext, yyleng,yylineno);
                  if (DEBUG) fprintf(logfd,"yytext: %s\n",yytext);
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
