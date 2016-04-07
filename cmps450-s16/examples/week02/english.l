%{
/* english.l
 * simple parts of speech recognition program
 *    $ lex english.l
 *    $ gcc -o english lex.yy.c -lfl
 *    $ cat fiddle | ./english
 *
*/

#include <stdio.h>
%}

/* this area is empty since we are not defining any regexes */

%%
[\t ]+                  /* ignore whitespace */
Hey                     { ; /* not sure what this is so ignore it */ }
[tT]he|[Aa]nd?|to       { ; /* ignore articles, conjunctions, infinitives */ }
over|away|with          { ; /* ignore prepositions */ }
jumped|laughed|ran|see  { printf("verb:      %s\n", yytext); }
little|such             { printf("adjective: %s\n", yytext); }
[a-zA-Z]+               { printf("noun:      %s\n", yytext); }
.|\n                    { ; /* ignore everything else 
                             *  ECHO is the default so if you do not want
                             * yytext displayed you must specify to ignore it 
                             */  
                        }
%%

int main()
{
  yylex();
  printf("done.\n");
  return 0;
}
