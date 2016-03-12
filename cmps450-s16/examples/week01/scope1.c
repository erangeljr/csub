/* scope1.c
 * demonstrate C's static scope rules 
 */

#include <stdio.h>
  
void funa();    /* a function name has external scope by default -
                 * the function definition linked in by linker */

int GLOBAL = 15;      /* variables outside functions have external scope  */
static int static_var = 15; /* keyword static assigns compilation unit scope */

int test(int *);
int test2(char *);
  
int main()
{    
   funa();
   printf("GLOBAL: %d\n",GLOBAL);
           
   /* main block */
   int w, x, y, z, n;      
   static int static_var = 15;   /* global to compilation unit */

      /* block S1 */
      { 
         int z;         
         y = 1;     /* references y in main block */
         z = 4;     /* references z in block  S1 */

         /* block S2 */
         { 
            int x, y;       
            w = 1;   /* references w in main block */
            y = 5;   /* references y to block S2  */
            x = 2;     
         }

         /* block S3 */
         { 
            int z;           
            x = 7;  /* references x in block S1 */
         } 
      }
      z = w + y + x;           // What is the value of z?
      printf("The value of z is: %d\n",z);

  return 0;

}
int  test(int * num) { return 0; } 
int  test2(char * num) { return 0; } 
