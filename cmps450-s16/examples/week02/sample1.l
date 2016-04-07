%{
 /*  sample1.l
  *
  *  A scanner that divides text into signed integer tokens and string tokens;
  *  uses sscanf to convert yytext into its integer value; ignores fractional
  *  part of number; also note top-down application of regexes by scanner
  *
  *     $ lex sample1.l
  *     $ gcc -o sample1 lex.yy.c -lfl
  *     $ cat data | ./sample1
  */ 

int amount;
int sum = 0;

%}


letter  [a-zA-Z]
digit   [0-9]
sign    [-+]

%%
{letter}+	       { printf("found an identifier ==> %s\n", yytext); }
{sign}?{digit}+	 { sscanf(yytext, "%d", &amount);
                   sum+=amount;
		               printf("found a number ==> %s\n", yytext);  
                 }
.|\n             {;}
%%

/* this function is called at EOF - if you do not supply yywrap the flex
 * library will supply one that simply returns 1
 */
int yywrap()
{
   printf("\n Total of integer values = %d\n", sum);
   return 1;
}
