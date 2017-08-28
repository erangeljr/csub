/* rev.c 
 * reverses a string passed in at cmdline or reverses a default hard-coded 
 * string if nothing is passed
 */
#include <stdio.h>
#include <string.h>

char mystr[128] = "supercalifrag\0";  /* hard-coded default string */
 
int main(int argc , char ** argv)
{
  char ch;
  int head, tail;

  /* if arg count==2 you know an arg was passed so use it instread of default */
  if (argc == 2) 
     strcpy(mystr,argv[1]); 

  head = 0;
  tail = 0;
  /* find the tail of the string */
  while ( (ch = mystr[tail]) != 0 )   
      tail++;
  tail--;  /* backup past null char */

  char tmp;
  while ( head < tail ) {
     tmp = mystr[head];
     mystr[head] = mystr[tail];
     mystr[tail] = tmp;
     head++;
     tail--;
  }

  printf("%s ",mystr);

  /* display a linefeed at the end (ascii value 10)*/
  printf("%c",10);

  return 0;
}
