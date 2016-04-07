/* binding.c
 * demonstrate static and dynamic binding of variables to addresses
 * variables that are dynamic are pushed onto the call frame
 * variables that are static are loaded into the .data segment
 */


#define MAX 99;           /* not bound to a memory address - MAX is replaced
                           * by 99 by preprocessor - 99 is a literal that is
                           * encoded into the instruction */

int myGlobal = 88;        /* external references to globals are bound by linker
                           * variables outside main are global by default */

static int myStatic = 77; /* myStatic and var2 are statically bound to memory 
                           * addresses by the compiler in the .data segment */


int  funcA(int num) { int x = 66; x = x + MAX; return 0; } 
  
int main() 
{  
  int mainX = 55;  /* x is stored in main's call frame on the runtime stack -
                    * mainX is bound to an offset to the base pointer; this 
                    * binding is dynamic since the address of the base pointer
                    * is not known at compile time */

  {
  static int myStatic = 44; /* the compiler will bind myStatic to another name
                             * so as not to clobber first myStatic and will
                             * bind this instance of myStatic to an address 
                             * in .data segment of the object file */
  } 
  char mainStr[33] = "a";   /* the compiler makes room for this string in the
                             * call frame for main on the stack  - space for 
                             * strings is allocated in chunks of 16 bytes so 
                             * this string is given 48 bytes ; see
                             * char-str.txt */

  mainStr[0] = 'b';         /* references to the string are made as offsets to
                             * the base pointer */ 
  return 0;
}
