/* gencode.c 
 * generates intermediate code for jumps to code.out
 *   $ cat demo.c | ./lab09
 *   $ more code.out
 */

#include "defs.h"
#include "y.tab.h"
#include <malloc.h>
#include <string.h>
#include <stdlib.h>

#define printError(_msg) { printf("Error: %s\n", _msg); }

LOCEntry *codeLines = NULL;
SymbolTableEntry *symbolTable = NULL;
SymbolTableEntry *queueHead = NULL;
LOCEntry *codeLineHead = NULL, *codeLineTail = NULL;

unsigned int funcOffset = 0;
extern int yylineno;
unsigned int globalOffset = 0;
unsigned int floatVarCount = 0;
unsigned int intVarCount = 0;
unsigned int boolVarCount = 0;
int currentLine = -1;

void yyerror() {
   printf("ERROR\n");
}

int main(void) {
   yyparse();
   FILE *outfd = fopen("code.out", "w");
   /* printSymbolTable(outfd); */
   printCode(outfd);
   fclose(outfd);
   return(0);
}

static const char* TypeToString(ST_TYPE type) {
    switch(type)
    {
      case ST_FUNC:
          return "Func";
      case ST_MAIN:
          return "Main";
      case ST_INT:
          return "Int";
      case ST_REAL:
          return "Real";
      default:
          return "None";
    }
}

/* generate new line of code; return pointer to that line */
LOCEntry *gencode(char *code){
   printf("In gencode\n");
   fflush(stdout);
   printf("%s\n",code);

   /* create new loc */
   LOCEntry* newLOC = malloc(sizeof(LOCEntry));
   newLOC->code = strdup(code);
   newLOC->next = NULL;
   newLOC->gotoL = -1;

   /* update the header/tail */
   if (codeLineHead == NULL){
      codeLineHead = newLOC;
      codeLineTail = newLOC;
   }
   else{
     codeLineTail->next = newLOC;
     codeLineTail = newLOC;
   }
   currentLine++;
   return newLOC;
}

/* inserts the target of the goto into the lists of code */
void backpatch(BackpatchList* list, int gotoL) {
   printf("In backpatch with %d\n", gotoL);
   fflush(stdout);
   if (list == NULL){
     return;
   } 
   else {
     BackpatchList* temp;
     while (list) {
        if (list->entry != NULL){
          list->entry->gotoL = gotoL;
        }
        printf("backpatching: %s\n",list->entry->code);
        temp = list;
        list = list->next;
        free(temp);
     }
   }
}

/* concatentate list b to tail of list a */
BackpatchList* listcat(BackpatchList* a, BackpatchList* b){
   printf("In listcat\n");
   fflush(stdout);
   if (a != NULL && b == NULL){
      return a;
   }
   else if (a == NULL && b != NULL){
     return b;
   }
   else if (a == NULL && b == NULL){
     return NULL;
   }
   else {
     BackpatchList* temp = a;
     while (a->next){
         a = a->next;
     }
     a->next = b;
     return temp;
   }
}

BackpatchList* addToList(BackpatchList* list, LOCEntry* entry){
   printf("In addToList\n");
   fflush(stdout);
   if(entry == NULL){
     return list;
   }
   else if(list == NULL){
     BackpatchList* newEntry = malloc(sizeof(BackpatchList));
     newEntry->entry = entry;
     newEntry->next = NULL;
     return newEntry;
   }
   else{
     BackpatchList* newEntry = malloc(sizeof(BackpatchList)), *temp = list;
     newEntry->entry = entry;
     newEntry->next=NULL;
     while(list->next){
       list = list->next;
     }
     list->next = newEntry;
     return temp;
   }
}

SymbolTableEntry* addSymbol(const char *name, ST_TYPE type, 
                  unsigned long offsetOrSize, unsigned long line, long index1, 
                  char *parent, unsigned long parameter)
{
    if (name == NULL || strcmp(name, "") == 0)
    {
      printError("name missing.\n");
      return 0;
    }

    if (parent != NULL && strcmp(parent, "None") == 0)
    {
      printError("Parent node is NULL or PARENT_NONE.\n");
      return 0;
    }

    SymbolTableEntry *symbol = malloc(sizeof(SymbolTableEntry));

    symbol->name = strdup(name);
    symbol->type = type;
    symbol->offsetOrSize = offsetOrSize;
    symbol->line = line;
    symbol->index1 = index1;
    symbol->parent = (parent == PARENT_NONE ? NULL : strdup(parent));
    symbol->parameter = parameter;
    symbol->next = NULL;

    SymbolTableEntry *tail = symbolTable;
    if (tail) {
      while(tail->next) tail = tail->next;
      tail->next = symbol;
    }
    else {
      symbolTable = symbol;
    }
    return symbol;
}


/* display code to code.out */
bool printCode(FILE *outfd) {
  LOCEntry *cur = codeLineHead;
  if (cur == NULL)
  {
    printError("Code Empty.");
    return false;
  }
  unsigned long lineNo = 0;

  if (fprintf(outfd, "\n") <= 0) {
     printError("Error printing to output file.");
     return false;
  }

  while (cur) {
     int ret;
     if (cur->gotoL == -1){
        ret = fprintf(outfd, "%-4lu %s\n", lineNo, cur->code);
     }
     else {
       ret=fprintf(outfd, "%-4lu %s %d\n", lineNo, cur->code, cur->gotoL);
     }
     if (ret <= 0)
     {
        printError("Error printing to output file.");
        return false;
     }
     cur = cur->next;
     ++lineNo;
   }
   return true;
}

/* dump symbol table to code.out */
bool printSymbolTable(FILE *outfd) {
  if(symbolTable == NULL) {
      printError("Symbol Table is Empty.");
      return false;
  }
  int ret = fprintf(outfd, "SymbolTable\n");
  ret=fprintf(outfd, "-----------\n");
  ret=fprintf(outfd,"Name   Type Offset Line Index1 Index2 Parent Parameter\n");
  ret=fprintf(outfd,"------ ---- ------ ----- ------ ----- ------ ---------\n");

  if(ret <= 0) {
    printError("Error printing to output file.");
    return false;
  }
  SymbolTableEntry *symbol = symbolTable;
  while(symbol) {
      ret = fprintf(outfd,"%-7s%-5s%-7lu%-7lu%-7ld%-7s%lu\n",
                    symbol->name,
                    TypeToString(symbol->type),
                    symbol->offsetOrSize,
                    symbol->line,
                    symbol->index1,
                    symbol->parent == NULL ? "None" : symbol->parent,
                    symbol->parameter);

      if(ret <= 0) {
         printError("Error printing to output file.");
         return false;
      }
      symbol = symbol->next;
  }
  return true;
}

/* clear the queue */
void clearQueue() {
   SymbolTableEntry *cur;
   while(queueHead != NULL) {
      cur = queueHead;
      queueHead = queueHead->next;
      free(cur);
   }
}


/* cleanup */
void freeLOCsAndSymbolTable() {
   LOCEntry *codeLine = codeLines;
   while(codeLine) {
      LOCEntry *next = codeLine->next;
      free(codeLine->code);
      free(codeLine);
      codeLine = next;
    }
    
   codeLines = NULL;
   SymbolTableEntry *symbol = symbolTable;

   while(symbol) {
      SymbolTableEntry *next = symbol->next;
      free(symbol->name);
      free(symbol->parent);
      free(symbol);
      symbol = next;
   }
   symbolTable = NULL;
}

/* add symtab entry to parameter queue */
SymbolTableEntry* addSymbolToParameterQueue(SymbolTableEntry* queue, char *name, ST_TYPE type) {
    SymbolTableEntry *symbol = malloc(sizeof(SymbolTableEntry));
    symbol->name = strdup(name);
    symbol->type = type;
    symbol->next = false;
    if (queue == NULL) {
      return symbol;
    } else {
      SymbolTableEntry *entry = queue;
      while (entry->next) {
          entry = entry->next;
      }
      entry->next = symbol;
      return queue;
    }
}

/* Found symbols are added to queue and transferred to the symbol table when
 * the parent is known  
 */
void addSymbolToQueue(char *name, ST_TYPE type, unsigned long param_no) {
   SymbolTableEntry *symbol = malloc(sizeof(SymbolTableEntry));
   symbol->name = strdup(name);
   symbol->type = type;
   switch(type){
      case ST_INT: symbol->offsetOrSize = 4;break;
      case ST_REAL: symbol->offsetOrSize = 8;break;
      default: symbol->offsetOrSize = 4;
    }
    symbol->parameter = param_no;
    
    if (queueHead == NULL) {
       queueHead = symbol;
    } else {
       SymbolTableEntry *entry = queueHead;
       while (entry->next) {
         entry = entry->next;
       }
       entry->next = symbol;
       symbol->next = NULL;
    }
}

/* add function symbol queue to symbol table */
void addFunc(char *name,unsigned param_cnt,int line) 
{
   SymbolTableEntry *symTable = symbolTable;
   SymbolTableEntry *newEntry = 
   addSymbol(name,ST_FUNC,4,line,0,NULL,param_cnt);
   int i=0;
   unsigned int internalOffset = 0;
   /* main function */
   if(strcmp(name, "main") == 0){
      SymbolTableEntry *newEntry;
   }
}

/* check if symbol is in table */
int getSymbolType(char *name) {
    SymbolTableEntry *cur;
    
    cur = queueHead;
    while(cur != NULL) {
      if(0 == strcmp(name, cur->name)) {
          return(cur->type);
      } else {
          cur = cur->next;
      }
    }
    return 0;
}


char* nextFloatVar(){
   char buffer[10];
   sprintf(buffer,"f_%d",++floatVarCount);
   addSymbolToQueue(buffer, ST_REAL, 0);
   return strdup(buffer);
}

char* nextIntVar(){
   char buffer[10];
   sprintf(buffer,"i_%d",++intVarCount);
   addSymbolToQueue(buffer, ST_INT, 0);
   return strdup(buffer);
}

int checkAndGenerateParams(SymbolTableEntry* queue, char* name,int paramCount){
   char buffer[50];
   SymbolTableEntry *cur = symbolTable;
   while(cur != NULL){
      if((cur->type == ST_FUNC) && 0 == strcmp(name,cur->name)){
        break;
      }
   }
   if(cur == NULL) return -1;
   //search for the parameters
   int foundParams = 0;
   cur = symbolTable;
   do {
     while(cur != NULL){
       //found entry
       if(cur->parent != NULL && 0 == strcmp(name,cur->parent) && cur->parameter != 0)
       { break; }
        cur = cur->next;
      }
      if(cur == NULL || queue == NULL){
         if(paramCount == 0 && foundParams == 0)
            return 0;
         else
            return -2;
      }
      else if(cur->type != queue->type){
          return -3;
      }
      foundParams++;
      sprintf(buffer,"PARAM %s",queue->name);
      gencode(buffer);
      cur = cur->next;
      SymbolTableEntry *temp = queue;
      queue = queue->next;
      free(temp);
  } while (foundParams != paramCount);
  return 0;
}

/* generates the next code lineno */
int nextlabel(){
  return currentLine + 1;
}


SymbolTableEntry* lookup(char *name){
  SymbolTableEntry* cur = symbolTable;
  while(cur!=NULL){
   if(cur->name != NULL && 0 == strcmp(name, cur->name)){
     break;
   }
   cur = cur->next;
  }
  return cur;
}
