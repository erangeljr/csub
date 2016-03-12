/* foo.c 
 * demonstrate static v. dynamic scoping 
 * in the context of scope, static or lexical scope means that a reference to 
 * a variable can be bound by the compiler; dynamic means that the reference
 * might change depending on the order in which things occur at runtime
 */

#include <stdio.h>

int x = 99;
int f() {return x;}
int g() {int x = 11; return f();}

int main ()
{
  /* what will be displayed ? */
  printf("%d\n",g());

  /* if C uses static scope then 99 will be displayed.
   * if C uses dynamic scope then 11 will be displayed.
   * /
 
  return 0;
}
 
  
