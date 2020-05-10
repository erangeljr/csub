/* pascal.cpp
 *----------------------------------------------------------------
 * calculate C(n,k) and display Pascal's triangle          
 *----------------------------------------------------------------
 *  $ g++ pascal.cpp
 *  ./a.out
 */ 
#include <iostream>
#include <iomanip>
#define MAX 12  

using namespace std;

static int cnt = 0;
typedef int PascalArray [ MAX ][ MAX ];
PascalArray p;

int  C( int n, int k );  // recursive function to calculate C(n,k)
void C2(int n,int k);    // display triangle using nonrecursion and an array
int  C3(int n,int k);    // nonrecursive function to calculate C(n,k)

int main () 
{
   int result;
   cout << "recursive function C(6,4): \n";
   result = C(6,4);
   cout << "Result: " << result << endl; 
   cout << "\nnon-recursive function C2(5,2) using array" << endl;
   C2(5,2);
   cout << "\nnon-recursive function C3(7,4): " << C3(7,4) << endl;
  return 0;
}  


/* ----------recursive algorithm to compute C(n,k) */
int C( int n, int k ){
    
    cnt++;
    cout << cnt << " n: " << n << " k: " << k << endl;
    if ( !k || (n == k))
      return 1;
    else
      return ( C(n-1,k) + C(n-1,k-1) );
}

/* ----------display triangle using nonrecursive algorithm and an array */
void C2( int n, int k )
{
int row, col;

   for (row = 0; row < MAX; row++)
      for(col = 0; col <= row; col++) {
         if (col == 0 || row == col)
            p[row][col] = 1;
         else
            p[row][col] = p[row-1][col] + p[row-1][col-1];
      } 

    /* display the triangle */
   for (row = 0; row < MAX; row ++){
      cout << setw( (2* MAX  - 2 * row)) << " ";  // move over an offset
      for (col=0; col <= row; col++) 
          cout << setw(4) << p[row][col];
      cout << endl;
   }
}

/* A non-recursive function that uses neither an array nor a stack.
   The answer to this problem required knowledge of the formula:
   C(n,k) = (the product as i goes from 1 to k of (n-i + 1))/i
   pre: n >= k >= 0     */

int C3(int n,int k){
  int i, answer = 1;

  for (i = 1; i <= k; i++)
       answer = (answer * (n + 1 - i)) / i;

   return answer;
}

/*------------------------------------------------------------------------

The recursive function requires space proportional to n and time
proportional to 2*C(n,k) = 2 (n/k(n-k))  

The non-recursive function requires constant time for each entry in
a n*n array, hence time proportional to n*n and space proportional to n*n.

The nonrecursive function requires time proportional to k and 
constant space.  */
