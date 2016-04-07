%{ 
/* counter.l
 * Lex program that counts lines and chars from standard input 
 * $ flex counter.l
 * $ gcc lex.yy.c -lfl
 * $ cat poem | ./a.out
 * 
 */

int num_lines = 0, num_chars = 0;
%}

%%
\n      {
         ++num_lines;
         ++num_chars;
        }
.       { ++num_chars;
        }
%%
int main()
{
  yylex();
  printf("Number of lines: %d \nNumber of chars: %d \n",
         num_lines, num_chars);
  return 0;
}
