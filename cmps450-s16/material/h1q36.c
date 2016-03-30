/* h1q36.c
*/
#define a (x + 1)

#include <stdio.h>

int x = 5;
void b() { int x = 1; printf("%d\n", a); }
void c() { printf ("%d\n", a); }
int main () 
{ b(); 
  c(); 
return 0; }

/*

gcc -E h1q36.c

# 1 "h1q36.c"
# 1 "<built-in>"
# 1 "<command-line>"
# 1 "h1q36.c"


int x = 5;
void b() { int x = 1; printf("%d\n", (x + 1)); }
void c() { printf ("%d\n", (x + 1)); }
int main ()
{ b();
  c();
return 0; }
*/
