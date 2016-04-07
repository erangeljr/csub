/* astar.l
 */ 

%option noyywrap 

%{ 
%}

%%
a*        { ; } 
%%

int main(int argc, char **argv)  {
  yylex(); 
  return 0;
}
