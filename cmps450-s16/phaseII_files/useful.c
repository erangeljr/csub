/* file: useful.c 
 * some useful c functions 
 */

#include <stdio.h>
#include <string.h>
#include <ctype.h>

int main () {
  float f;
  int n = __INT_MAX__;
  char big_int[20] = "999999999999999";
  int m = atoi(big_int); 
  if ( m < 0 )  {
     printf ("Overflow: %d\n",m);
     printf ("MAX INT: %d\n",n);
  }
  /* or you could */
  if ( strlen(big_int) > 10 )  
     printf ("Overflow: %d\n",m);


  /* c does not differentiate between number types */
  for (f=1; f <= 5; f++)
    ;

  return 0;
}

  /* also useful
     atof ( char * )   // converts the character string into float value
     int atoi ( char * )   // converts the character string into integer value
     int strlen (char *)   // returns string length  - from string.h
     int isdigit ( int )   // returns 1 if true  - from ctype.h
     int isalpha ( int )   // returns 1 if true  - from ctype.h
  */

  
/*Overflow: -1530494977
MAX INT: 2147483647 */
