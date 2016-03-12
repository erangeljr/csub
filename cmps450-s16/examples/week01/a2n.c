/* a2n.c
 * takes a string and converts it to number 
 */
#include <stdlib.h>
#include <stdio.h>
#include <string.h>

int main (int argc, char **argv)
{
   if (argc == 1) {
      printf("Usage: ./a2n <string>");
      exit(0);
   }
   char myStr[100];
   strncpy(myStr,argv[1],strlen(argv[1]));
   int i;
   long int num = 0;
   for (i = 0; i < strlen(myStr); i++)
       num = num + myStr[i];
   printf("%s = %ld \n",myStr,num); 

   return 0;
}
