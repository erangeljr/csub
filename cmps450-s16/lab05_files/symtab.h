/****************************************************/
/* File: symtab.h                                   */
/****************************************************/

#ifndef _SYMTAB_H_
#define _SYMTAB_H_

#include <stdio.h>

/* inserts token and its line number */
void insert( char * name, int type, int lineno );

/* returns 1 if found or -1 if not found */
int lookup ( char * name );

/* by default FILE is defined as stdout */
void symtab_dump(FILE * of);

#endif
