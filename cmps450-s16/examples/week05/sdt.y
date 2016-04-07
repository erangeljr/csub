%{
/* sdt.y
 * implement static semantic type checking for expressions of this type:
 *     4 + 10    VALID
 *    4.5 + 7    INVALID 
 * The parser does not evaluate the expression - its only purpose
 * is to implement the sdd. Verbose output is set by YYDEBUG flag.
 *     $ make
 *     $ cat data | ./sdd
*/

#include <stdio.h>

#define YYDEBUG 0 
extern int yylineno;
void yyerror(char *);

%}


/* declare tokens */
%token INTEGER REAL

%start list 

%%

list:  expr '\n'         { if ($$ == -1) 
                            printf("Expression failed semantic type check.\n"); 
                           else
                            printf("Type check semantics met!\n");
                         }
         |
       error '\n'        { yyerrok; }
         |
       list expr '\n'
         ;

expr:  expr '+' term     { 
                             if ($1 != $3) { 
                                $$ = -1; 
                                yyerror("FAILED semantic type check"); 
                             }
                             else  {
                                $$ = $1; 
                                printf("good so far.\n");
                             }
                          }
         |
       
        term              { $$ = $1; }
         ;

term:    INTEGER          { $$ = INTEGER; }
         |
         REAL             { $$ = REAL; } 
         ;

%%
int yydebug = 1;

int main() { 
  printf("\nEnter expression (5 + 2 or 3.4 + 2.3) or Ctrl-D to terminate:\n");
  return(yyparse()); 
}

yywrap()
{ return(1); }

void yyerror (char *s) 
{ fprintf(stderr, "%s: line %d\n", s, yylineno); }
