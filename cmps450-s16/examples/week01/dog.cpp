/* dog.cpp
 * run top to compare footprint to similar code in java
 * $ g++ -o dog dog.cpp
 *
 * open another terminal window - watch virtual and resident memory
 * top -u username
 *
 * ./dog
 */

#include <iostream>
#include <string>

using namespace std;

int fib(int n) {
   if (n == 0) return 0;
   if (n == 1) return 1;
   return fib(n-1) + fib(n-2);
}

class Dog {
   private:
      string name;
   public:
      Dog (string s) {name = s;}
      void setName (string s) {name = s;}
      string getName () {return name;}
};

int main()
{
   Dog d1 = Dog("fido");
   d1.setName("fluffy"); 
   cout << d1.getName() << endl;

   /* do some busy work to give yourself time to see footprint in top */ 
   fib(45);

   return 0;
}

