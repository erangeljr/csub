%{
 /*  file: lab04s.l
  *  demonstrate the structure of a lex generated scanner based on 
  *  language covered in lecture week 04
  *
  *     $ lex hw04.l
  *     $ gcc -o lab04 -7 -d -T lex.yy.c -lfl
  *     $ ./lab04
  *       Enter input string and hit Ctrl-D
  */
%}

%%
(a|b)*abb	 { printf("valid token: %s\n", yytext); } 
%%

int main()
{
   /* scan until EOF */
   while( yylex() != 0 );
   return 0;
}
