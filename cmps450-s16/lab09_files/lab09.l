/* lab09.l */

%option noyywrap
%option nomain
%option yylineno
%option case-insensitive

%{
#include <stdio.h>
#include <string.h>
#include "defs.h"
#include "y.tab.h"

%}

NEWLINE (\n|\n\l|\r\n)
WHITESPACE (" "|\t)
SINGLELINE_COMMENT ("//".*{NEWLINE})
MULTILINE_COMMENT ("/*".*"*/")
INTEGER (0|[1-9][0-9]*)
FLOAT (0\.0|[1-9][0-9]*\.[0-9]+)
IDENT ([a-zA-Z_][a-zA-Z0-9_]*)

%%

({NEWLINE}+|{WHITESPACE}+) {; }

({SINGLELINE_COMMENT}|{MULTILINE_COMMENT}) {; }

("("|")"|"{"|"}"|"="|";"|",") {
    return(yytext[0]);
}

"int"         { return(INT); }

"if"          { return(IF); }

"else"        { return(ELSE); }

"return"      { return(RET); }

"while"       { return(WHILE); }

"=="          { return(EQ); }

"<="          { return(LE); }

{INTEGER} {
    /* allocate memory for a new string - copy yytext to new string */
    yylval.expr.value = strdup(yytext);
    return(NUM);
}

{FLOAT} {
    /* allocate memory for a new string - copy yytext to new string */
    yylval.expr.value = strdup(yytext);
    return(NUM);
}

{IDENT} {
    /* this does the same thing that strdup does */
    yylval.str = malloc(strlen(yytext)*sizeof(char)+1);
    strcpy(yylval.str, yytext);
    return(IDENT);
}

%%
