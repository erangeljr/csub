/* foo.c 
 * $ gcc -fdump-tree-cfg 
 */
int   i =  5;   

int main ( int i, float x ) 
{
    i = 5;   
    x = 13.2;
    return 1.2;   /* downcasts to 1 */
}  
