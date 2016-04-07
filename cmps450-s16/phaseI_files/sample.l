/* sample.l                                                           
 * CMPS 450 - Phase I sample file to demonstrate the use of the symbol table 
 * all it reads is identifiers and integers
 * $ make
 * $ ./sample
 *   type some identifiers
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

int col_cnt = 0;
typedef enum 
{
  ENDFILE, ERROR, IDENT, NUMBER
} 
TokenId;

char *TokenNames[3] =
{ "Unknown", "Identifier", "Number"};

typedef enum 
{  Unknown, Identifier, Number } 
TokenType;

TokenType type = Unknown; 
 
%}

id_char     [A-Z_a-z]
identifier  {id_char}([0-9]|{id_char})*
number      [0-9]+ 
%%

{identifier}    { type = Identifier; 
                  insert(yytext,yyleng, yylineno );
                  return IDENT;
                }
{number}        { type = Number;
                  return NUMBER;
                }        
\n              { col_cnt = 1; }

[ ]             { col_cnt+=yyleng; }

.               { type = Unknown; 
                  return ERROR;
                }

%%

TokenId getToken(void) {  

   TokenId currentToken;
   char errmsg[MAX_MSG_LEN] = "";

   // static cast the return value into a TokenId enumerated type
   currentToken = (TokenId) yylex();

   /* EOF returns 0 */
   if (currentToken > 0) { 
        printf("%-7s line%3d, %-8s\n",yytext,yylineno,TokenNames[type]);
   }

   return currentToken;
}

int main()
{
   while (getToken() != 0);

   /* dump symbol table */
   if (DEBUG) {
      printf("\n==================\n");
      printf(" Symbol Table Dump\n");
      printf("==================\n");
      symtab_dump(stdout);
      printf("\nEnd Symbol Table Dump\n");
      printf("@@\n");
   }

   return 0;
}
