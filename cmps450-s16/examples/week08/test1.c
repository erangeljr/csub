/* test1.c 
 * $ gcc -fdump-tree-gimple-verbose
 * $ gcc -fdump-tree-original-raw test1.c
 * $ gcc -fdump-tree-cfg-verbose test1.c   # dumps control flow graph
 * $ gcc -fdump-tree-ssa-verbose test1.c   # dumps static single assignment 
 *
 */
int   globInt =  55;   
float globFloat = 5.5;   

int main ( int argInt, float argFloat ) 
{
    globInt = 77;   
    argFloat = 55.5;   
    globFloat = 99.2;
    while (globInt > 0)
    {
       globInt = globInt - 1;
    }
    return 1.2;   /* downcasts to 1 */
}  
