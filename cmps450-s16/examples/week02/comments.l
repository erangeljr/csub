%{
/* comments.l
 *   strip C++ style comments and leave C style comments alone 
 *   $ lex comments.l 
 *   $ gcc -o comments lex.yy.c -lfl
 *   $ cat test-comments.c | ./comments
 *
 *  Notes:
 *   . matches any character except newline
 *
 *   \n is matched inside [^a] unless you explicitly exclude it: [^a\n]
 *
 *  There is a context sensitive issue in this program in that the
 *  newline is gobbled up by the cPlusComment rule whether the comment
 *  is a full line or a trailing comments - so text with trailing comments 
 *  is printed on the same line as the next line
 */

#include <stdio.h>

%}

Cstart          [ \t]*\/\*.*\n
Cend            .*\*\/[ \t]*\n

text            [^\/]+       

cPlusComment    [ \t\n]*\/\/.*\n

%%
{Cstart}           { printf("%s",yytext); } 
{Cend}             { printf("%s",yytext); } 
\/[^\/]            { printf("%s",yytext); }
{text}             { printf("%s",yytext); } 
{cPlusComment}     { ;}
%%

int main()
{
   yylex(); return 0;
}

