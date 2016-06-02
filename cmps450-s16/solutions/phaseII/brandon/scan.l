%{
#include <stdbool.h>
#include <stdio.h>
#include <string.h>
#include <ctype.h>
#include <stdlib.h>
#include <limits.h>
#include "symtab.h"
#include "parse.tab.h"

typedef enum
{
    NONE, KW, OP, NUM, ID, PUNC, CHARACTER_CONST, STRING_CONST, COMMENT
} TokenType;
char *tokenTypes[] = {"", "keyword", "operator", "number", "identifier",
                         "punctuator", "character constant", "string constant"
                     };
int line_cnt = 0;
int col_cnt = 0;
int token_cnt;

int getToken(int currentToken, TokenType type);

%}

sign          [+-]
digit         [0-9]
number        {digit}+
fp_rhs_req    {digit}*\.{digit}+
fp_lhs_req    {digit}+\.
fp_exp        ([eE]{sign}{digit}+)
float         {sign}?(({fp_rhs_req}|{fp_lhs_req}){fp_exp}?|{digit}+{fp_exp})

letter        [a-zA-Z]
ident         ({letter}|_)({letter}|{digit}|_)*
ident_bad     [^a-zA-Z_ \t\n\[{(]{ident}
ctrl_char     \\[\\"'nrbtfav?]
char_const    '([ -&(-[\]-~]|{ctrl_char})'
char_bad      \'.
string_const  \"([ !#-[\]-~]|{ctrl_char})*\"
string_bad    \"[^"]*

ws            [ \t]+
comment       \/\*([^*]|(\/[^*]))*\*\/
comment_bad   \/\*.*\*\/

%%

{comment}       {}
{comment_bad}   {return getToken(COMMENT, ERROR);}

{number}        {return getToken(UINT, NUM);}
{float}         {return getToken(FP, NUM);}

"void"          {return getToken(VOID, KW);}
"int"           {return getToken(INT, KW);}
"char"          {return getToken(CHAR, KW);}
"float"         {return getToken(FLOAT, KW);}

"break"         {return getToken(BREAK, KW);}
"goto"          {return getToken(GOTO, KW);}
"else"          {return getToken(ELSE, KW);}
"if"            {return getToken(IF, KW);}
"read"          {return getToken(READ, KW);}
"return"        {return getToken(RETURN, KW);}
"while"         {return getToken(WHILE, KW);}
"write"         {return getToken(WRITE, KW);}

"=" |
"+" |
"-" |
"*" |
"/" |
"%"             {return getToken(yytext[0], OP);}

"++"            {return getToken(INCR, OP);}
"--"            {return getToken(DECR, OP);}
"=="            {return getToken(EQ, OP);}
"!="            {return getToken(NE, OP);}
">"             {return getToken(GT, OP);}
"<"             {return getToken(LT, OP);}
">="            {return getToken(GT_EQ, OP);}
"<="            {return getToken(LT_EQ, OP);}
"&&"            {return getToken(AND, OP);}
"||"            {return getToken(OR, OP);}

"[" |
"]" |
"(" |
")" |
"{" |
"}" |
";" |
","             {return getToken(yytext[0], PUNC);}

{char_const}    {return getToken(CHAR_CONST, CHARACTER_CONST);}
{char_bad}      {return getToken(ERROR, CHARACTER_CONST);}
{string_const}  {return getToken(STR_CONST, STRING_CONST);}
{string_bad}    {return getToken(ERROR, STRING_CONST);}
"\n"            {col_cnt=0; ++line_cnt;}
{ws}            {col_cnt += yyleng;}

{ident}         {return getToken(IDENT, ID);}
{ident_bad}     {return getToken(ERROR, ID);}
.               {return ERROR;}

%%

int getToken(int currentToken, TokenType type)
{ /* FIXME: not the most elegant code */
    printf("line %d, col %d: ", line_cnt+1, col_cnt+1);

    if (currentToken == ERROR)
        switch (type)
        {
        case COMMENT:
            printf("ERROR: illegally nested comments");
            break;
        case CHARACTER_CONST:
            if (yyleng == 2)
                if (yytext[1] == '\'')
                    printf("ERROR: empty character constant ''");
                else
                    printf("ERROR: missing quote at end of char \"%s\"",
                           yytext);
            else
                printf("ERROR: unknown char %s", yytext);
            break;
        case STRING_CONST:
            printf("ERROR: missing quote at end of string %s", yytext);
            break;
        case ID:
            printf("ERROR: invalid identifier \"%s\"", yytext);
            break;
        case NONE:
            printf("ERROR: invalid character \"%s\"", yytext);
            break;
        /* none of these can happen (silence compiler warnings) */
        case KW:
        case OP:
        case NUM:
        case PUNC:
            break;
        }
    else
        switch (type)
        {
        case OP:
        case PUNC:
            printf("%s", yytext);
            break;
        case NUM:
            if (currentToken == UINT)
            {
                long num = strtol(yytext, (char **)NULL, 0);
                if (num > INT_MAX || errno == ERANGE)
                {
                    printf("ERROR: integer \"%s\" is too large", yytext);
                    break;
                }
            }
            /* fall through */
        case ID:
        case STRING_CONST:
            yylval.tokname = strdup(yytext);
            if (!yylval.tokname)
            {
                fprintf(stderr, "Out of memory!");
                exit(1);
            }
            /*insert(yytext, yyleng, line_cnt+1, col_cnt+1);*/
            insert(yytext, yyleng, currentToken, line_cnt+1);
            /* fall through */
        default:
            printf("%s %s", tokenTypes[type], yytext);
        }
    printf("\n");
    type = NONE;
    ++token_cnt;
    col_cnt += yyleng;

    return currentToken;
}
