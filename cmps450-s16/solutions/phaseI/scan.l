/* scan.l                                                           
 * CMPS 450 - Phase I scanner   SOLUTION                        
 * $ make
 * $ cat good.cf | ./scan
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

typedef enum 
{
  ENDFILE, ERROR, 
  WHILE, IF, ELSE, RETURN, INT,FLOAT,CHAR,

  ASSIGN, EQ, LT, LE, GE, GT, NE, AND, OR, PLUS, MINUS, TIMES, OVER, MOD,
  PLUSEQ, MINUSEQ,

  COMMA, LPAREN, RPAREN,SEMI, LBRACK, RBRACK, LCURLY, RCURLY,
  FCONST, CCONST, ICONST, SCONST, ID 
} 
TokenId;

char *TokenNames[9] =
{ "Unknown", "Keyword", "Identifier", "Operator", "Punctuator", "charConst",
  "strConst", "intConst", "floatConst" };

typedef enum 
{  Unknown, Keyword, Identifier, Operator, Punctuator, charConst, 
   strConst, intConst, floatConst 
} 
TokenType;

TokenType type = Unknown; 
 
int badtoken_cnt = 0;
int token_cnt = 0;
int id_cnt = 0;
int op_cnt = 0;
int cconst_cnt = 0;
int fconst_cnt = 0;
int iconst_cnt = 0;
int sconst_cnt = 0;
int keywd_cnt = 0;
int punct_cnt = 0;

int col_cnt = 0;
int line_cnt = 0;

%}

comment     \/\*([^*]|\n)*\*\/
digit       [0-9]
id_char     [A-Z_a-z]
digits      {digit}+
exponent    (e[+-]{digits})?
integer     [+-]?{digits}
efloat      {integer}\.?e[+-]{digits}
dotfloat    {integer}\.{digit}*
float       ({efloat}|{dotfloat})
newline     \n
identifier  {id_char}([0-9]|{id_char})*
strchar     ([ ~]|\\n)
whitespace  [ \t]+
chrliteral  '([!-}]|\\n)'
strliteral  \"[^"]*{escquote}*\"
nullstring  \"\"
escquote    [^"]*\\\"[^"]*
%%

"char"          { type = Keyword; keywd_cnt++; return CHAR;}
"int"           { type = Keyword; keywd_cnt++; return INT;}
"float"         { type = Keyword; keywd_cnt++; return FLOAT;}
"if"            { type = Keyword; keywd_cnt++; return IF;}
"else"          { type = Keyword; keywd_cnt++; return ELSE;}
"while"         { type = Keyword; keywd_cnt++; return WHILE;}
"return"        { type = Keyword; keywd_cnt++; return RETURN;}

"="             { type = Operator; 
                  op_cnt++;
                  return ASSIGN;}
"!="            { type = Operator; 
                  op_cnt++;
                  return NE;}
"=="            { type = Operator; 
                  op_cnt++;
                  return EQ;}
"<"             { type = Operator; 
                  op_cnt++;
                  return LT;}
"<="            { type = Operator; 
                  op_cnt++;
                  return LE;}
">"             { type = Operator; 
                  op_cnt++;
                  return GT;}
">="            { type = Operator; 
                  op_cnt++;
                  return GE;}
"+"             { type = Operator; 
                  op_cnt++;
                  return PLUS;}
"-"             { type = Operator; 
                  op_cnt++;
                  return MINUS;}
"*"             { type = Operator; 
                  op_cnt++;
                  return TIMES;}
"/"             { type = Operator; 
                  op_cnt++;
                  return OVER;}
"%"             { type = Operator; 
                  op_cnt++;
                  return MOD;}
"+="            { type = Operator; 
                  op_cnt++;
                  return PLUSEQ;}
"-="            { type = Operator; 
                  op_cnt++;
                  return MINUSEQ;}
"{"             { type = Punctuator; 
                  punct_cnt++; 
                  return LCURLY;}
"}"             { type = Punctuator; 
                  punct_cnt++; 
                  return RCURLY;}
"["             { type = Punctuator; 
                  punct_cnt++; 
                  return LBRACK;}
"]"             { type = Punctuator; 
                  punct_cnt++; 
                  return RBRACK;}
"("             { type = Punctuator; 
                  punct_cnt++; 
                  return LPAREN;}
")"             { type = Punctuator; 
                  punct_cnt++; 
                  return RPAREN;}
";"             { type = Punctuator; 
                  punct_cnt++; 
                  return SEMI;}
","             { type = Punctuator; 
                  punct_cnt++; 
                  return COMMA;}

{float}         { type = floatConst; 
                  //insert(yytext,yyleng, yylineno );
                  fconst_cnt++;
                  return FCONST;
                }

{integer}       { type = intConst; 
                  iconst_cnt++;
                  return ICONST;
                }


{chrliteral}    { type = charConst; 
                  //insert(yytext,yyleng, yylineno );
                  cconst_cnt++;
                  return CCONST;
                }

{nullstring}    { type = strConst; 
                  //insert(yytext,yyleng, yylineno );
                  sconst_cnt++;
                  return SCONST;
                }

{strliteral}    { type = strConst; 
                  //insert(yytext,yyleng, yylineno );
                  sconst_cnt++;
                  return SCONST;
                }

{identifier}    { type = Identifier; 
                  insert(yytext,yyleng, yylineno );
                  id_cnt++;
                  return ID;
                }
{newline}       { col_cnt = 1; }

{whitespace}    { col_cnt+=yyleng; }

{comment}       { col_cnt = 0; }

"//"            { /* handle C++ style comments */
                    char c;
                    do { c = input();
                    } while (c != '\n');
                    line_cnt++;
                }

.               { type = Unknown; 
                  /* eat up chars until the next space */
                  char c;
                  do { c = input();
                  } while (c != ' ');
                  return ERROR; 
                }

%%

TokenId getToken(void) {  

   static int firstTime = TRUE;
   TokenId currentToken;
   char errmsg[MAX_MSG_LEN] = "";

   int aok = TRUE;  // flag to control static semantics

   // initialization 
   if (firstTime)
   {   firstTime = FALSE;
       line_cnt++;
       yyin = stdin;
       yyout = stdout;
       printf("\n");
   }

   // static cast the return value into a TokenId enumerated type
   currentToken = (TokenId) yylex();

   // handle case of EOF first
   if (currentToken == ENDFILE) return 0;

   col_cnt+= yyleng;
   
   // handle case of invalid symbol in input stream next
   if (currentToken == ERROR){
      aok = FALSE;
      badtoken_cnt++;
      strcpy(errmsg, "Error: encountered symbol not in language");
      printf("%-7s line%3d,col%3d %-40s\n",yytext,yylineno,col_cnt,errmsg);
   }

   if (aok) {
      token_cnt++;
      printf("%-7s %-8s\n", yytext, TokenNames[type]);
   }
   return currentToken;
}

int main()
{
   /* scan until EOF */
   printf("\n==============\n");
   printf("SCANNER OUTPUT  ");
   printf("\n==============\n");

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

   printf("\n====================\n");
   printf(" Token Count Summary\n");
   printf("=====================\n");
   printf("Keywords:    %d\n",keywd_cnt);
   printf("Operators:   %d\n",op_cnt);
   printf("Punctuators: %d\n",punct_cnt);
   printf("intConsts:   %d\n",iconst_cnt);
   printf("floatConsts: %d\n",fconst_cnt);
   printf("charConsts:  %d\n",cconst_cnt);
   printf("Identifiers: %d\n",id_cnt);
   printf("strConsts:   %d\n",sconst_cnt);

   printf("\nTOTAL TOKENS:%d\n",token_cnt);
   printf("BAD TOKENS:  %d\n",badtoken_cnt);

   return 0;

}
