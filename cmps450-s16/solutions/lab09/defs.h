/* defs.h */

#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>

typedef enum {ST_FUNC,ST_MAIN,ST_ARRAY,ST_NONE,ST_INT,ST_REAL} ST_TYPE;
typedef enum { C_CONSTANT, C_VARIABLE, C_NONE } CONSTANT_TYPE;
#define PARENT_NONE NULL

typedef struct _SymbolTableEntry {
    char *name;
    ST_TYPE type;
    unsigned long offsetOrSize, line;
    long index1;
    char *parent;
    unsigned long parameter;
    struct _SymbolTableEntry *next;
} SymbolTableEntry;

typedef struct {
    char *name;
    int type;
    float	floatValue;
    int	intValue;
} ExpressionInfo;

typedef ExpressionInfo* expression;

typedef struct Entry {
    char *code;
    int gotoL;
    struct Entry *next;
} LOCEntry;

typedef struct List {
    LOCEntry *entry;
    struct List *next;
} BackpatchList;

LOCEntry *gencode(char *code);

void backpatch(BackpatchList* list, int gotoL); 
BackpatchList* listcat(BackpatchList* a, BackpatchList* b);
BackpatchList* addToList(BackpatchList* list, LOCEntry* entry);
SymbolTableEntry* addSymbol(const char *name, ST_TYPE type,
               unsigned long offsetOrSize, unsigned long line, long index1,
               char *parent, unsigned long parameter);

bool printCode(FILE *outputFile);
bool printSymbolTable(FILE *outputFile);

SymbolTableEntry* addSymbolToParameterQueue(SymbolTableEntry* queue, char *name, ST_TYPE type);

void freeCodeLinesAndSymbolTable();
int checkAndGenerateParams(SymbolTableEntry* queue, char* name ,int paramCnt);
int getFunctionType(char *name);
int getSymbolType(char *name);
char* nextFloatVar();
char* nextIntVar();
char* nextBoolVar();
int nextlabel();
void addFunc(char *name, unsigned param_cnt, int line);
SymbolTableEntry* lookup(char *name);
extern SymbolTableEntry *symbolTable;
