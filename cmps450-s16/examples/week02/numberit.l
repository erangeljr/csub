%{
 /*  numberit.l
  *  a Lex program to insert line numbers and display to standard output
  *      $ lex numberit.l
  *      $ gcc -o numberit lex.yy.c -lfl
  *      $ cat data | ./numberit
  */

#include <stdio.h>

int lineno = 1;

%}

line .*\n

%%

{line}  {printf("%5d %s", lineno++, yytext); }

%%

/* main is constructed for you by flex if you do not explicitly have one */
int main()
{
   printf("Now processing from standard input \n");

   /* you can change globals from your own main if you want to */
   lineno = 0;

   /* yylex is the actual scanner routine so you have to call it. */
   yylex();

   return 0;
}
