/* scan.l                                                           
 * CMPS 450 - Phase II scanner   SOLUTION                        
 * $ make
 * $ ./cf 100.cf
 */

%option yylineno

%{
#define TRUE 1 
#define FALSE 0 
#define MAXTOKENLEN 40 
#define MAX_MSG_LEN 50 

#include <stdio.h>
#include <ctype.h>
#include <string.h>
#include "y.tab.h"
#include "defs.h"

extern FILE *logfd;
char buf[10];
int col_cnt = 0;
extern int scope;  /* incremented by parser -scope is appended to IDENT name */ 
extern int pflag; /* let's scanner know if inside parameter list */

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
strchar     ([ ~]|\\n)
identifier  {id_char}([0-9]|{id_char})*
whitespace  [ \t]+
chrliteral  '([!-}]|\\n)'
strliteral  \"[^"]*{escquote}*\"
nullstring  \"\"
escquote    [^"]*\\\"[^"]*
%%

"char"          { /* parser can set this type but let scanner do it jic */
                  yylval.toktype = CTYPE; return CHAR;
                }
"int"           { yylval.toktype = ITYPE; return INT;}
"float"         { yylval.toktype = FTYPE; return FLOAT;}
"if"            { return IF;}
"else"          { return ELSE;}
"while"         { return WHILE;}
"return"        { return RET;}

"="             { return ASSIGN;}
"!="            { return NE;}
"=="            { return EQ;}
"<"             { return LT;}
"<="            { return LE;}
">"             { return GT;}
">="            { return GE;}
"+"             { return PLUS;}
"-"             { return MINUS;}
"*"             { return TIMES;}
"/"             { return OVER;}
"+="            { return PLUSEQ;}
"-="            { return MINUSEQ;}
"["             { return LBRACK;}
"]"             { return RBRACK;}
"("             { return LPAREN;}
")"             { return RPAREN;}
"{"             { return LCURLY;}
"}"             { return RCURLY;}
";"             { return SEMI;}
","             { return COMMA;}

{float}         { 
                 /* copy yytext to attribute bucket - let parser do atoi */
                 yylval.name = malloc(sizeof(yytext));
                 strncpy(yylval.name,yytext,yyleng);
                 if (DEBUG) fprintf(logfd,"Float Constant: %s\n",yylval.name);
                 return FCONST; 
                }

{integer}       { 
                 /* copy yytext to attribute bucket - let parser do atoi */
                 yylval.name = malloc(sizeof(yytext));
                 strncpy(yylval.name,yytext,yyleng);
                 if (DEBUG) fprintf(logfd,"Int Constant: %s\n",yylval.name);
                 return ICONST; 
                }

{chrliteral}    { 
                 return CCONST; }

{nullstring}    { return SCONST; }

{strliteral}    { return SCONST; }

{identifier}    { 
                  yylval.name = malloc(sizeof(yytext)+10);
                  char myname[50];
                  int found = 0;
                  /* if global scope then insert as new variable */
                  if (scope==0) {
                     /* append scope to identifier name */
                     strncpy(yylval.name,yytext,yyleng);
                     sprintf(buf,"%d",scope);
                     strcat(yylval.name,buf);
                     insert(yylval.name,strlen(yylval.name), yylineno );
                   if (DEBUG) fprintf(logfd,"scope %d: %s\n",scope,yylval.name);
                  }
                  else  if (pflag)
                  {
                     myname[0] = '\0';
                     strncpy(myname,yytext,yyleng+2);
                     strcat(myname,"1\0");
                 if (DEBUG) fprintf(logfd,"myname scope %d: %s\n",scope,myname);
                     strncpy(yylval.name,myname,strlen(myname));
                     insert(yylval.name,strlen(yylval.name), yylineno );
                  }
                  else {
                     /* check if local first */
                     myname[0] = '\0';
                     strncpy(myname,yytext,yyleng+2);
                     strcat(myname,"1\0");
                     found = lookup(myname);
                      /* if we found it - it is a local reference */
                     if (found != -1) { 
                        strncpy(yylval.name,myname,strlen(myname));
                         /* insert lineno */
                        insert(yylval.name,strlen(yylval.name), yylineno );
           if (DEBUG) fprintf(logfd,"yylval scope %d: %s\n",scope,yylval.name);
                     }
                     /* assume it a global variable so insert lineno */
                     else {
                        myname[0] = '\0';
                        strncpy(myname,yytext,yyleng+2);
                        strcat(myname,"0\0");
                        strncpy(yylval.name,myname,strlen(myname));
                        insert(yylval.name,strlen(yylval.name), yylineno );
                 //  fprintf(logfd,"yylval scope %d: %s\n",scope,yylval.name);
                     }
                  }
                if (DEBUG) fprintf(logfd,"ident yylval: %s ",yylval.name);
               return IDENT;
             }

{newline}       { col_cnt = 1; }

{whitespace}    { col_cnt+=yyleng; }

{comment}       { col_cnt = 0; }

"//"            { /* handle C++ style comments */
                    char c;
                    do { c = input();
                    } while (c != '\n');
                }

.               { 
                  /* eat up chars until the next space */
                  char c;
                  do { c = input();
                  } while (c != ' ');
                  return ERROR; 
                }

%%
