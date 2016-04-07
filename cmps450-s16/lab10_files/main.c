/* main.c
 *
 */

#include "globals.h"
#include "tree.h"
#include "analyze.h"
#include "gencode.h"

/* global variables */
int lineno = 1;
FILE *yyin;
FILE *yyout;
FILE *fp;
FILE *listing;
FILE *code;

/* allocate and set tracing flags */
int EchoSource = TRUE;
int TraceScan = TRUE;       /* lexical analysis */
int TraceParse = TRUE;      /* syntax analysis */
int TraceAnalyze = TRUE;    /* emits comments during semantic analysis */
int TraceCode = FALSE;      /* emits comments during code generation */
int Error = FALSE;

TreeNode * syntaxTree;  /* the parser sets this to root of syntax tree */
void codeGen(TreeNode * syntaxTree, char * codefile); 

int main( int argc, char * argv[] )
{ 
  char infile[120]; /* input file name */
  if (argc != 2)
  { fprintf(stderr,"usage: %s <filename>\n",argv[0]);
      exit(1);
  }
  strcpy(infile,argv[1]) ;
  if (strchr (infile, '.') == NULL)
     strcat(infile,".tny");
  fp = fopen(infile,"r");
  if (fp==NULL)
  { fprintf(stderr,"File %s not found\n",infile);
    exit(1);
  }
  yyin = fp;
  listing = stdout; /* send listing to screen */
  int ret = yyparse();
  if (TraceParse) {
    fprintf(listing,"\nSyntax tree:\n");
    printTree(syntaxTree);
  }
  if (! Error)
  { if (TraceAnalyze) fprintf(listing,"\nBuilding Symbol Table...\n");
    buildSymtab(syntaxTree);
    if (TraceAnalyze) fprintf(listing,"\nChecking Types...\n");
    typeCheck(syntaxTree);
    if (TraceAnalyze) fprintf(listing,"\nType Checking Finished\n");
  }
  if (! Error)
  { char * codefile;
    int fnlen = strcspn(infile,".");
    codefile = (char *) calloc(fnlen+4, sizeof(char));
    strncpy(codefile,infile,fnlen);
    strcat(codefile,".code");
    code = fopen(codefile,"w");
    if (code == NULL)
    { printf("Unable to open %s\n",codefile);
      exit(1);
    }
    codeGen(syntaxTree,codefile);
    fprintf(listing,"\nCode generation to %s complete.\n",codefile);
    fclose(code);
  }
  fclose(fp);
  return 0;
}
