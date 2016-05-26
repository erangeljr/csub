/****************************************************/
/* File: symtab.h                                   */
/****************************************************/

#ifndef _SYMTAB_H_
#define _SYMTAB_H_

#include <stdio.h>
#include "y.tab.h" 

#define ITYPE 0
#define RTYPE 1 
#define CTYPE 2 

/* inserts token and its line number and returns -1 if error*/
void insert( char * name, int len, int type, int lineno );

/* returns symbol value if found or -1 if not found */
int lookup ( char * );

/* returns token datatype if found or -1 if not found */
int lookupType( char * );

/* sets datatype of token to t returns -1 if not found else 0 */
int setType( char * name, int t );

/* by default FILE is defined as stdout */
void symtab_dump(FILE * of);

#endif
