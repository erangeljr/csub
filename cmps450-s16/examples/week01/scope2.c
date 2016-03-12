/* scope2.c
 * demonstrate external linkage
 */

#include <stdio.h>

static int static_var = 99;

void funa( )
{
   extern GLOBAL;  /* this will be linked in by linker */
   GLOBAL = 99;
}
