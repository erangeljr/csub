%{
 /*  file: hw04s.l
  *  demonstrate the structure of a lex generated scanner based on the
  *  language in problem #4 of homework 4.
  *
  *     $ lex hw04.l
  *     $ gcc -o hw04 lex.yy.c -lfl
  *     $ ./hw04
  *       Enter input string and hit Ctrl-D
  */
%}

letter     [a-z]
digit      [0-9]
%%
{letter}({letter}|{digit})+	   { printf("valid token: %s\n", yytext); } 
%%

int main()
{
   /* scan until EOF */
   while( yylex() != 0 );
   return 0;
}
