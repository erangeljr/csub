%{
/*----------------------------------------------------------- *
 * Filename: lab02.l                                          *
 * Purpose:  a Lex specification for a small set of tokens    *
 *            modify this program for lab 2                   *
 *                                                            *
 *  $ lex lab02.l                                             *
 *  $ gcc -o lab02 lex.yy.c -lfl                              *
 *  $ cat test.cf | ./lab02                                   *
 *                                                            *
 *----------------------------------------------------------- */

#define TRUE 1 
#define FALSE 0 
#define MAXTOKENLEN 40 

#include <stdio.h>

typedef enum 
{ERROR=1, IF,THEN,ELSE,END,REPEAT,UNTIL,ID,NUM,READ,WRITE,ASSIGN,EQ,LT,PLUS,
  MINUS,TIMES,OVER,LPAREN,RPAREN,SEMI} Token;

char *tokenTypes[1] = {"Unknown"};  /* you will add to this structure */

typedef enum
{ Unknown } TokenType;   /* you will add to this list */

TokenType tok_id = Unknown;

int line_cnt=0;
int token_cnt=0;

%}

digit       [0-9]
number      {digit}+
letter      [a-zA-Z]
identifier  {letter}+
newline     \n
whitespace  [ \t]+

%%

"if"            {return IF;}
"then"          {return THEN;}
"else"          {return ELSE;}
"end"           {return END;}
"repeat"        {return REPEAT;}
"until"         {return UNTIL;}
"read"          {return READ;}
"write"         {return WRITE;}
":="            {return ASSIGN;}
"="             {return EQ;}
"<"             {return LT;}
"+"             {return PLUS;}
"-"             {return MINUS;}
"*"             {return TIMES;}
"/"             {return OVER;}
"("             {return LPAREN;}
")"             {return RPAREN;}
";"             {return SEMI;}
{number}        {return NUM;}
{identifier}    {return ID;}
{newline}       {line_cnt++;}
{whitespace}    {/* skip whitespace */}
"{"             { char c;
                  do
                  { c = input();
                    if (c == '\n') line_cnt++;
                  } while (c != '}');
                }
.               {return ERROR;}

%%

Token getToken(void) { 
   static int firstTime = TRUE;
   Token currentToken;

  // initialization 
  if (firstTime)
  {   firstTime = FALSE;
      line_cnt++;
      /* you can reassign yyin and yyout if you want -
       * the next two lines demonstrate how should you want to
       */
      yyin = stdin;
      yyout = stdout;
      printf("\n");
  }
  currentToken = (Token) yylex();

  /* currentToken is 0 at EOF so do not process it */
  if (currentToken != 0) {
       token_cnt++;
       printf("\t<%s, %d, %d\t>\n", yytext, line_cnt, token_cnt);
   }
  return currentToken;
}

int main()
{
  /* yylex() returns 0 at EOF */
  while( getToken() != 0 );
  printf("\nTOTAL TOKEN CNT: %d\n",token_cnt);

  return 0;
}
