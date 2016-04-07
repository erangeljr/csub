/* test-comments.c 
 *
 * test the ability of a flex scanner to strip C++ style comments
 * $ cat test-comments.c | ./comments
 */

// this source is littered with C++ style comments
int main () {  
  int num = 5; // the comment rule will gobble up the newline 
// this is a return value 
  return 0;  
}
