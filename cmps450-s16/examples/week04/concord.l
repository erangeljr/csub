/* concord.l
 * taken from flex & bison text
 * fb2-4 text concordance 
 * uses a hash table with linear probing 
 */ 

%option noyywrap nodefault yylineno case-insensitive

%{

#include <string.h>
void printrefs();

%}

/* the symbol table */
%{

   struct symbol { 
      char *name; /* a word */
      struct ref *reflist;
   };

   struct ref {  
      struct ref *next; 
      char *filename; 
      int flags; 
      int lineno;
   };

   /* simple symtab of fixed size */ 
   #define NHASH 9997 
   struct symbol symtab[NHASH];

   struct symbol *lookup(char*); 
   void addref(int, char*, char*,int);
   char *curfilename;  /* name of current input file */

%} 

/* rules for concordance generator */ 
%% 
a |          /* skip all these common words */
an | 
and |
are | 
as | 
at | 
be | 
but | 
for | 
in | 
is | 
it | 
of | 
on | 
or | 
that | 
the | 
this | 
to                  /* ignore all of the above */

[a-z]+(\'(s|t))?   { addref(yylineno, curfilename, yytext, 0); } 
.|\n               /* ignore everything else */
%%

/* concordance main routine */ 
main(int argc, char **argv) 
{
   int i;

   /* if no args passed read stdin */ 
   if (argc < 2) { 
      curfilename = "(stdin)"; 
      yylineno = 1; 
      yylex();
   } else 
   for (i = 1; i < argc; i++) {
       FILE *f = fopen(argv[i], "r");
       if (!f) { 
          perror(argv[1]);
          return (1);
       }
       curfilename = argv[i];
       yyrestart(f);
       yylineno = 1; 
       yylex(); 
       fclose(f);
   }

   printrefs();
   return 0;
}

/* symhash function */ 
unsigned int symhash(char *sym) 
{
   unsigned int hash = 0; 
   unsigned c;
   while(c = *sym++) 
        hash = hash*9 ^ c; 
    return hash;
}

struct symbol * lookup(char* sym)
{
   struct symbol *sp = &symtab[symhash(sym)%NHASH]; 
   int scount = NHASH;  /* this is how many have we looked at */
   while(--scount >= 0) { 

        if (sp->name && !strcmp(sp->name, sym)) 
            return sp;

        /* new entry */
        if(!sp->name) { 
            sp->name = strdup(sym); 
            sp->reflist = 0; 
            return sp;
        }
        if (++sp >= symtab+NHASH) 
            sp = symtab;  /* try the next entry */

   } 
   /* if we made it here we have tried them all, table is full */
   fputs("symbol table overflow\n", stderr); 
   abort(); 
}

void addref(int lineno, char *filename, char *word, int flags)
{
    struct ref *r; 
    struct symbol *sp = lookup(word);

    /* don't do dups of same line and file */ 
    if (sp->reflist &&
        sp->reflist->lineno == lineno && sp->reflist->filename == filename) 
        return;
    r = malloc(sizeof(struct ref)); 

    if (!r)  {
       fputs("out of space\n", stderr); 
       abort(); 
    } 
    r->next = sp->reflist; 
    r->filename = filename; 
    r->lineno = lineno; 
    r->flags = flags; 
    sp->reflist = r;
}

/* print the references 
 * sort the table alphabetically 
 * then flip each entry's reflist to get it into forward order 
 * and print it out 
*/

/* aux function for sorting */ 

static int symcompare(const void *xa, const void *xb) 
{
   const struct symbol *a = xa; 
   const struct symbol *b = xb;
   if (!a->name) {
      if (!b->name) 
         return 0;  /* both empty */ 
      return 1;  /* put empties at the end */
   } 
   if (!b->name) return -1; 
   return strcmp(a->name, b->name);
}

void printrefs()
{
   struct symbol *sp;
   /* sort table */
   qsort(symtab, NHASH, sizeof(struct symbol), symcompare); 

   for (sp = symtab; sp->name && sp < symtab+NHASH; sp++)  {
     char *prevfn = NULL;  /* last printed filename, to skip dups */

      /* reverse the list of references */ 
      struct ref *rp = sp->reflist; 
      struct ref *rpp = 0;  /* previous ref */
      struct ref *rpn;

      do { 
        rpn = rp->next; 
        rp->next = rpp; 
        rpp = rp; 
        rp = rpn;  /* next ref */
      } while(rp);

      /* now print the word and its references */ 
      printf("%10s", sp->name); 

      for (rp = rpp; rp; rp = rp->next) {
         if (rp->filename == prevfn) { 
            printf(" %d", rp->lineno);
         } else { 
            printf(" %s:%d", rp->filename, rp->lineno);
            prevfn = rp->filename; 
         }
      }
      printf("\n");
   }
}
