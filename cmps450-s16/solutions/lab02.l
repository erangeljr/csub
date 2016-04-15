%{
/* -----------------------------------------------------------------* 
 *  filename: lab02.l                                               *      
 *  project: Lab 02 SOLUTION                                        * 
 *  purpose: write a lex scanner to classify and display lexemes    * 
 *  in sample cflat program                                         *
 *                                                                  *     
 *    $ lex lab02.l                                                 *     
 *    $ gcc -o lab02 lex.yy.c -lfl                                  * 
 *    $ cat test.cf | ./lab02                                       *
 -------------------------------------------------------------------*/

#define TRUE 1 
#define FALSE 0 
#define MAXTOKENLEN 40 

#include <stdio.h>

typedef enum {ENDFILE, ERROR, IF,THEN,ELSE,END,REPEAT,UNTIL,READ,WRITE,ID,NUM, 
 REAL, ASSIGN,EQ, LT,PLUS,MINUS,TIMES,OVER,LPAREN,RPAREN,SEMI, PLUSEQ   
} Token;

/* structures to manage token classification */
char * TokenTypes[6]=
  {"Unknown", "Number", "Keyword", "Identifier","Operator", "Punctuator"};

typedef enum 
{  Unknown, Number, Keyword, Identifier, Operator, Punctuator } 
TokenType;

TokenType tok_id = Unknown;  
int lineno=0;
int token_cnt=0;
%}

/* note: the regex for a float is not complete - the full regex is left for
 * you to complete in phaseI of the project
 */

comment     [ \t]*\/\*.*\*\/[ \t]*\n
digit       [0-9]
integer     {digit}+
letter      [a-zA-Z]
exponent    e[+-]{integer}
float       {integer}*\.{integer}{exponent}?
identifier  {letter}+
newline     \n
whitespace  [ \t]+

%%

"if"            {tok_id = Keyword; return IF;}
"then"          {tok_id = Keyword; return THEN;}
"else"          {tok_id = Keyword; return ELSE;}
"end"           {tok_id = Keyword; return END;}
"repeat"        {tok_id = Keyword; return REPEAT;}
"until"         {tok_id = Keyword; return UNTIL;}
"read"          {tok_id = Keyword; return READ;}
"write"         {tok_id = Keyword; return WRITE;}
":="            {tok_id = Operator; return ASSIGN;}
"="             {tok_id = Operator; return EQ;}
"<"             {tok_id = Operator; return LT;}
"+="            {tok_id = Operator; return PLUSEQ;}
"+"             {tok_id = Operator; return PLUS;}
"-"             {tok_id = Operator; return MINUS;}
"*"             {tok_id = Operator; return TIMES;}
"/"             {tok_id = Operator; return OVER;}
"("             {tok_id = Punctuator; return LPAREN;}
")"             {tok_id = Punctuator; return RPAREN;}
";"             {tok_id = Punctuator; return SEMI;}

{comment}       {;}
{float}         {tok_id = Number; return NUM;}
{integer}       {tok_id = Number; return NUM;}
{identifier}    {tok_id = Identifier; return ID;}
{newline}       {lineno++;}
{whitespace}    {/* skip whitespace */}
"{"             { char c;
                  do
                  { c = input();
                    if (c == '\n') lineno++;
                  } while (c != '}');
                }
.               { tok_id = Unknown; return ERROR; }

%%

Token getToken(void) { 

   static int firstTime = TRUE;
   Token currentToken;

   /* initialization  */
   if (firstTime)
   {   firstTime = FALSE;
       lineno++;
       yyin = stdin;
       yyout = stdout;
       printf("\n");
   }

   /* static cast the return value from yylex() into a Token enumerated type */
   currentToken = (Token) yylex();

   /* EOF returns 0 */
   if (currentToken > 0) { 
        token_cnt++;
        printf("%-7s line%3d, %-8s\n",yytext,lineno,TokenTypes[tok_id]);
   }

   return currentToken;
}


int main()
{
   /* scan until EOF - getToken() returns 0 at EOF */
   while (getToken() != 0);

   printf("\nTOTAL TOKEN CNT: %d\n",token_cnt);

   return 0;
}
