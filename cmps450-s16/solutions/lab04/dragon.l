%{
 /*  dragon.l
  *  demonstrate the internal structures that lex uses to generate a scanner 
  *  the tables in the dump are created by lex before it creates lex.yy.c
  *
  *   $ lex hw04a.l
  *   $ gcc -o lab04a -7 -d -T lex.yy.c -lfl     
  *   $ ./lab04a
  *      Enter valid regex following by Enter. Hit Ctrl-D to end.
  */
%}

%option noyywrap

%%
(a|b)abb                  { printf("%s\n", yytext); } 
%%

int main()
{
   while( yylex() != 0 );
   return 0;
}
