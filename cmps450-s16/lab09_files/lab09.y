/* lab09.y 
 * cmps 450 
 * demonstate code generation for IF ELSE statements by backpatching */

%{
#include <stdio.h>
#include <string.h>
#include "defs.h"

#define YYDEBUG 1

int yydebug = 1;

extern int yylineno;
extern char *yytext;
char codeBuffer[50];
int funcLineno = 0;

%}

/* silence parser warning */
%name parser

%right '='
%left EQ LE

%union {
   char *str;
   int integer;
   float real;
   int type;
   struct {
      char *value;
      int type;
      BackpatchList* trueList;
      BackpatchList* falseList;
   } expr;
   struct {
       BackpatchList* nextList;
   } stmt;
   struct {
     int label;
     BackpatchList* nextList;
   } mark;
}

%token <str> IDENT
%token <expr> NUM
%token <type> INT 
%token EQ LE IF ELSE RET WHILE 

%type <str> id 
%type <expr> expr assign cond
%type <stmt> stmt stmt_list prog func_body func
%type <mark> mark jump_mark
%start head

%%

head: prog 
      {
         SymbolTableEntry* mainFunc = lookup("main");
         if(mainFunc == NULL){
           printf("ERROR: Main func not found!\n");
           yyerror();
         }
         backpatch($1.nextList,mainFunc->line+1);
      }
      ;

prog: jump_mark func 
      {
         printf("PARSER: Processing func.\n");
         $$.nextList = $1.nextList;
         backpatch($2.nextList, nextlabel());
         printf("PARSER: Done processing func.\n");
      }
      ;

func: INT id '(' ')' func_body 
      {
        addFunc($2, 0, funcLineno);
        funcLineno = nextlabel();
        $$.nextList = $5.nextList;
      }
      ;

func_body: '{' stmt_list '}'
      {
         printf("PARSER: found func body \n");
         $$.nextList = $2.nextList;
      }
      ;

stmt_list: stmt
      {
         printf("PARSER: Processing single stmt in stmt_list.\n");
         $$.nextList = $1.nextList;
         printf("PARSER: Done processing single stmt in stmt_list.\n");
      }
      | stmt_list mark stmt
      {
         printf("PARSER: Processing stmt list.\n");
         backpatch($1.nextList,$2.label);
         $$.nextList = $3.nextList;
         printf("PARSER: Done processing stmt list.\n");
      }
      ;
/* $$  $1 $2  $3   $4  $5   $6   $7        $8   $9  $10   */
stmt: IF '(' cond ')' mark stmt jump_mark ELSE mark stmt
      {
         printf("PARSER: Processing if else.\n");
         backpatch($3.trueList,$5.label);
         backpatch($3.falseList,$9.label);
         $$.nextList = listcat($7.nextList,$10.nextList);
         $$.nextList = listcat($$.nextList,$6.nextList);
         printf("PARSER: Done processing if else.\n");
      }
      | assign ';'
      {
         printf("PARSER: Processing assign.\n");
         $$.nextList = NULL;
         printf("PARSER: Done processing assign.\n");
      }
      | RET NUM ';'
      {
         printf("PARSER: Processing return.\n");
         $$.nextList = NULL;
         sprintf(codeBuffer,"RETURN %s",$2.value);
         gencode(codeBuffer);
         printf("PARSER: Done processing return.\n");
      }
      | WHILE '(' cond ')' stmt 
      {
         printf("PARSER: Processing while.\n");
         printf("PARSER: Done processing while.\n");
      }
      ;

assign: id '=' expr
      {
          printf("PARSER: found assignment\n");
          sprintf(codeBuffer,"%s := %s",$1,$3.value);
          gencode(codeBuffer);
          $$.trueList = $3.trueList;
          $$.value = $1;
      }
      ;
cond: expr EQ expr 
      {
          printf("PARSER: Processing equal.\n");
          sprintf(codeBuffer,"IF (%s == %s) GOTO",$1.value,$3.value);
          $$.trueList = addToList(NULL, gencode(codeBuffer));
          sprintf(codeBuffer,"GOTO");
          $$.falseList = addToList(NULL, gencode(codeBuffer));
          $$.trueList = listcat($$.trueList, $1.trueList);
          $$.falseList = listcat($$.falseList, $1.falseList);
          $$.trueList = listcat($$.trueList, $3.trueList);
          $$.falseList = listcat($$.falseList, $3.falseList);
          $$.value = "TrueFalse";
          printf("PARSER: Done processing logical equal.\n");
      }
      | expr LE expr 
      {
         printf("PARSER: Processing less than or equal.\n");
         sprintf(codeBuffer,"IF (%s <= %s) GOTO",$1.value,$3.value);
         $$.trueList = addToList(NULL, gencode(codeBuffer));
         sprintf(codeBuffer,"GOTO");
         $$.falseList = addToList(NULL, gencode(codeBuffer));
         $$.value = "TrueFalse Only!";
         printf("PARSER: Done processing logical less than or equal.\n");
     }
     ;
expr:  id
     {
        printf("PARSER: Processing identifier.\n");
        $$.value = $1;
        printf("PARSER: Done processing identifier.\n");
     }
     | NUM 
     {
        printf("PARSER: Processing number constant.\n");
        $$.value = strdup(yytext);
        $$.trueList = NULL;
        $$.falseList = NULL;
        printf("PARSER: Done processing number constant.\n");
     }
     ;

id: IDENT
     {
        printf("PARSER: found identifier %s\n", $1);
        $$ = strdup(yytext);
     }
     ;

mark: 
     {
        printf("PARSER: Generating mark.\n");
        $$.label= nextlabel();
        printf("PARSER: Done with the mark.\n");
     };

jump_mark: 
     {
       printf("PARSER: Generating jump mark.\n");
       $$.label= nextlabel();
       sprintf(codeBuffer,"GOTO");
       $$.nextList = addToList(NULL, gencode(codeBuffer));
       printf("PARSER: Done with the jump mark.\n");
     };
%%
