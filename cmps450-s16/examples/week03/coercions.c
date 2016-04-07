/* c-coercions.c
 * various ways that C coerces one data type to another
 */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

char token[25] = "3.45";

union {
   float f;
   int  i;
   char c;
} myUnion;

int main() {

   int i = 99;
   int i = 5-5;
   float x = 3.4;
   myUnion.f = x;
   myUnion.c = i;  /* coerce int to char */
   myUnion.i = x;  /* coerce int to char */


   x = atof(token);
   printf("string to float: %5.2f\n",x);

   /* copy a literal integer to the token string */
   strcpy(token,"345");

   /* convert string to its integer value */
   i = atoi(token);
   printf("string to int: %5d\n",i);

   /* convert a float to a string with sprintf */ 
    x = 99.99;
   sprintf(token,"%5.2f",x);
   printf("float to string: %s\n",token);

   /* convert an int to a string with sprintf */ 
    i = 1234;
   sprintf(token,"%d",i);
   printf("int to string: %s\n",token);
   
   
   return 0;

}
