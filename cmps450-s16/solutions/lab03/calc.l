/* calc.l        CMPS 450 LAB 3 SOLUTION
 * a scanner for an input stream of digits and characters -
 * will pass ascii decimal equiv of the first character of all valid tokens 
 * to the parser - will set the value for digits in yylval.digit 
 *
 */

%option yylineno

%{
#include <stdlib.h>
#include <stdio.h>
#include "y.tab.h"

int c;  

%}

%%             /* rules section begins here */

" "              ;                       /* this rule means ignore spaces */

[0-9]*\.[0-9]+   { yylval.fval =  atof(yytext); 
                   return(FLOAT); 
                 }

                  /* grab the character and convert
                   * it into its index into symtab 
                   */
[a-z]            { c = yytext[0];         
                   yylval.a_z = c - 'a';    
                   return(LETTER);        
                 }                         
       

[0-9]+           { yylval.dval = atoi(yytext); return(INTEGER); }

[^a-z0-9\b]      { return(yytext[0]);}  /* all other lexemes match this RE 
                                         * \b anchors regex at a word boundary 
                                         * 1-127 are reserved for ascii chars 
                                         */ 
