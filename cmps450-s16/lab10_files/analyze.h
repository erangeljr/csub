/* file: analyze.h
 */

#ifndef _SYMTAB_H_
#define _SYMTAB_H_

/* construct symbol table by preorder traversal of the syntax tree */
void buildSymtab(TreeNode *);

/* perform type checking by a postorder traversal of the syntax tree */
void typeCheck(TreeNode *);

#endif
