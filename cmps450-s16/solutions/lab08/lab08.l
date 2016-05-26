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

newline		\n
whitespace	[ \t]
%%


{whitespace}  {}

{newline}     { 
                 return NL; 
              }

"a"	          { 
                 yylval.s = (char*)malloc(sizeof(char) * 1024); 
                 sprintf(yylval.s, "a");
                 return A; 
              }

"b"           { 
                 yylval.s = (char*)malloc(sizeof(char) * 1024); 
                 sprintf(yylval.s, "b");
                 return B; 
              }

"c"           { 
                 yylval.s = (char*)malloc(sizeof(char) * 1024); 
                 sprintf(yylval.s, "c");
                 return C; 
              }

"("	          { 
                 return LPAR; 
              }

")"           { 
                 return RPAR; 
              }

"+"           { 
                 return PLUS; 
              }

"-"           { 
                 return MINUS; 
              }

"*"           { 
                 return MULT; 
              }

"/"           { 
                 return DIV; 
              }

%%
