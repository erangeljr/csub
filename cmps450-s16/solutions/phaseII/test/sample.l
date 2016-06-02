/* sample.l                                                           
 * CMPS 450 - Phase I sample file to demonstrate fusing lex file with yacc file 
 *
 * all this parser reads is identifiers and integers
 *
 *    $ make sample
 *    $ ./sample
 *       type some identifiers
 */

%option yylineno

%{
#define DEBUG  1 
#define TRUE 1 
#define FALSE 0 
#define MAXTOKENLEN 40 
#define MAX_MSG_LEN 50 

#include <stdio.h>
#include <ctype.h>
#include <string.h>
#include "y.tab.h"

int col_cnt = 0;

/* yacc will assign a token number to these tokens:
 *  ENDFILE, ERROR, IDENT, NUMBER
 */

%}

id_char     [A-Z_a-z]
identifier  {id_char}([0-9]|{id_char})*
number      [0-9]+ 
whitespace  [ \t\n]+
%%

{identifier}    { insert(yytext,yyleng, yylineno );
                  return IDENT;
                }
{number}        { return NUMBER;
                }        

{whitespace}    { col_cnt+=yyleng; }

.               { 
                  return ERROR;
                }

%%
