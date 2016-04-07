/*  calc.c
 *  C routines used to create ast for calc parser
 *  these routines could have gone in the third section of the parser, but 
 *  easier to debug if you modularize things
 */

#include <stdio.h>
#include <stdlib.h>
#include <stdarg.h>
#include "calc.h"

struct ast * newast(int nodetype, struct ast *l, struct ast *r)
{
   struct ast *a = malloc(sizeof(struct ast));
   if(!a) {
      yyerror("out of space");
      exit(0);
   }
   a->nodetype = nodetype;
   a->l = l;
   a->r = r;
   return a;
}

struct ast * newnum(double d)
{
   struct numval *a = malloc(sizeof(struct numval));
   if(!a) {
      yyerror("out of space");
      exit(0);
   }
   a->nodetype = 'K';
   a->number = d;
   return (struct ast *)a;
}

/* two tree-walking routines - a depthfirst traversal of the tree, recursively 
 * visiting the subtrees of each node and then the node itself. The eval 
 * routine returns the value of the tree or subtree from each call, and
 * the treefree does not have to return anything.
*/

double eval(struct ast *a)
{
   double v; /* calculated value of this subtree */
   switch(a->nodetype) {
      case 'K': v = ((struct numval *)a)->number; 
                 printf("Current node value: %5.2f\n",v);
                 break;
      case '+': v = eval(a->l) + eval(a->r); break;
      case '-': v = eval(a->l) - eval(a->r); break;
      case '*': v = eval(a->l) * eval(a->r); break;
      case '/': v = eval(a->l) / eval(a->r); break;
      case '|': v = eval(a->l); if(v < 0) v = -v; break;
      case 'M': v = -eval(a->l); break;
      default: printf("internal error: bad node %c\n", a->nodetype);
   }
   return v;
}

void treefree(struct ast *a)
{
   switch(a->nodetype) {
   /* two subtrees */
      case '+':
      case '-':
      case '*':
      case '/':
         treefree(a->r);
      /* one subtree */
      case '|':
      case 'M':
          treefree(a->l);
      /* no subtree */
      case 'K':
         free(a);
         break;
      default: printf("internal error: free bad node %c\n", a->nodetype);
   }
}

void yyerror(char *s, ...)
{
   va_list ap;
   va_start(ap, s);
   fprintf(stderr, "%d: error: ", yylineno);
   vfprintf(stderr, s, ap);
   fprintf(stderr, "\n");
}

int main()
{
   printf("> ");
   return yyparse();
}
