%{
 /*  file: lab04.l
  *
  *  solution to lab04  - demonstrate the structure of a lex generated scanner
  *
  *     $ lex lab04.l
  *     $ gcc -o lab04 lex.yy.c -lfl
  *     $ cat data | ./lab04
  */ 

%}

%%
a		         { printf("token a: %s\n", yytext);   }
abb	         { printf("token abb: %s\n", yytext); }
a*b+	       { printf("token a*b+: %s\n", yytext); } 
%%

int main()
{
   /* scan until EOF */
   while( yylex() != 0 );
   return 0;
}
