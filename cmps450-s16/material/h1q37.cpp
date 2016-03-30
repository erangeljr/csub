/* h1q37.cpp
   demonstrates use of reference type and parameter passing mechanisms in cpp 
*/

#include <iostream>

using namespace std;


int funa(int & x, int y) {

   /*  x is an alias to size so changes made to x are propogated to main;
    *  y is a pass-by-value formal parameter and changes made to y
    *  are not changed to actual parameter in calling routine 
   */
 
    x++;           /* this increments stuff in main and x here to 7 */
    y=0;           /* y is local to funa only - changes nothing in main */
    return x + y;  /* return value 7 is passed on the stack - 
                     no surprize here */
}

int main(){
   int size = 5;         /* size is local to main */

   int & stuff = size;   /* this is an alias to size called stuff - 
                          * this is not a ptr! */

   stuff++;                 /* increment size to 6 - its alias reflects this */
   cout << "Size: " << size << endl;

   cout << funa(stuff,size);   /* pass the alias to size and size itself 
                                  the return value 14 is displayed - */
   cout << " stuff:" << stuff;
   cout << " size:" << size;   /* size did not get changed to 0 */
   cout << endl;
}

/* 14 stuff:6  size:6  */
