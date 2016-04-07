/* vowel.l
 * matches vowels or consonants lines of text 
 */ 

%option noyywrap 

%{ 
#include <string.h>
int v_cnt = 0;
int c_cnt = 0;
%}

%%
[aeiou]                 { v_cnt++; } 
[bcdfghjklmnpqrstvwxyz] { c_cnt++; } 
%%

int main(int argc, char **argv)  {
  if (argc > 1)  {
      if(!(yyin = fopen(argv[1], "r"))) {
        perror(argv[1]); 
        return (1);
      }
  }
  yylex(); 
  printf("There are %8d vowels and %8d consonsants.\n", v_cnt, c_cnt);
  return 0;
}
