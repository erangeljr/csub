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
newline         \n
whitespace      [ \t]+

%%

"*"             { return TIMES; }
"+"             { return PLUS; }
"("             { return LPAREN; }
")"             { return RPAREN; }



"id"            { return IDENT; }

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
