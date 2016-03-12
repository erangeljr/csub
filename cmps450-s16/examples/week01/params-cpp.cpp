/* params-cpp.cpp
 * demonstrate C++ call by reference, C call by value and function side-effects
 */

#include <iostream>
using namespace std;

int funb(int n, int *iptr, int **idptr ){
   (**idptr)++;    // gnu requires parenthesis
   (*iptr)++;
   n++;
   return n + (*iptr) + (**idptr);
}

int funa(int & ref1, int & ref2){
   ref1++;   // these statements will modify the value in calling routine
   ref2++;   
   return ref1 + ref2;
}

int main(){

   int size = 5;
   int & iref = size;        // iref is a reference (aka alias) for size
   cout <<  "iref: " << iref << " size: " << size << endl;
   iref++;                   // since iref is an alias, size is incremented
   cout <<  "iref: " << iref << " size: " << size << endl;

   // funa call by reference and function side-effects
   cout << "What is displayed? " << funa(iref,iref) << "Size: " << size << endl;

   // demonstrate call by value with pointers

   int i = 0;
   int j = 0;
   int * jptr = &j;
   int ** dblptr = &jptr;

   cout << funb(i,jptr,dblptr) << endl;  // What value is returned? 

   return 0;
}
