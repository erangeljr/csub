/* sample.y
 * example use of union to provide different types to yylval
 *
 * sample accepts things like this:
 *  a = 7.4 + 4
 * the output follows bottom-up parsing so is out of order  -
 * the program doesn't compute expression - it is just to demonstrate %union  
 */

%{ 
void yyerror(char *s);

%}

%union {
   int int_val;
   char *str_val;
   char op_val;
}

/* assign each token a type for yylval */
%token <op_val> OP ASSIGN
%token <str_val> NAME 
%token <int_val> NUMBER 

/* assign non-terminals a type for yylval */
%type <int_val> expression

%%

/* demonstrate the various yylval types by sending %s,%c and %d format flags */
equation: NAME ASSIGN expression {  
                                    printf("(NAME)%s",$1);  
                                    printf("(ASSIGN)%c",$2);  
                                    return 0;
                                 };

expression: NUMBER              { printf("(NUMBER)%d",$1); }
          | NUMBER expression   { printf("(NUMBER)%d",$1); }
          ;                     

%%

int yywrap() { return 1; }

void yyerror(char *s) 
{
 fprintf(stderr,"%s\n",s);
}

int main( int argc, char **argv ) {
  yyparse();
  printf("\n");
  return 0;
}

