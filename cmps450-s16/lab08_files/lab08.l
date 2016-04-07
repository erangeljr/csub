%{
  /* lab08.l
   * 
   * scans from file input such as
   *      (a-b) * -(b+c) * a
   * and constructs a node for identifiers and operators which the parser will
   * use to construct an abstract parse tree
   *
   * for sanity check spits out each token as it reads it
   */   

#include <stdlib.h>
#include <string.h>
#include "y.tab.h"
%}

newline    \n
whitespace  [ \t]
%%


{whitespace}  {}

{newline}     { 
                 printf("\n");
                 return NL; 
              }

"a"           { 
                 yylval.s = (char*)malloc(sizeof(char) * 1024); 
                 sprintf(yylval.s, "a");
                 printf("%s","a");
                 return A; 
              }

"b"           { 
                 yylval.s = (char*)malloc(sizeof(char) * 1024); 
                 sprintf(yylval.s, "b");
                 printf("%s","b");
                 return B; 
              }

"c"           { 
                 yylval.s = (char*)malloc(sizeof(char) * 1024); 
                 sprintf(yylval.s, "c");
                 printf("%s","c");
                 return C; 
              }

"("           { 
                 printf("%s","(");
                 return LPAR; 
              }

")"           { 
                 printf("%s",")");
                 return RPAR; 
              }

"+"           { 
                 printf("%s","+");
                 return PLUS; 
              }

"-"           { 
                 printf("%s","-");
                 return MINUS; 
              }

"*"           { 
                 printf("%s","*");
                 return MULT; 
              }

"/"           { 
                 printf("%s","/");
                 return DIV; 
              }

%%
