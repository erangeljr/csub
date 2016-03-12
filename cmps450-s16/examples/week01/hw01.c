/* hw01.c
 * demonstrates some problems from the homework
 */

#include <stdio.h>

/* problem 36 */
#define a (x + 1)
int x = 99;
void c() { printf ("from c(): %d\n", a); }
void b() { int x = 1; printf("from b(): %d\n", a); c(); }


/* problem 38 */
void funa ( int x[2], int y[2] )
{
  printf ("x[0]=%d\n", x[0]); 
  x[0] = 2;
  printf ("y[0]=%d\n", y[0]); 
}

int main ( )
{ int arr[2] = {0};
  printf ("Problem 38.\nBefore Call: arr[0]=%d. arr[1]=%d\n", arr[0], arr[1]); 
  funa (arr,arr);
  printf ("\nProblem 36.\nMain calls b()\n");
  b(); 
  printf ("main calls c()\n");
  c();
  return 0;
}
