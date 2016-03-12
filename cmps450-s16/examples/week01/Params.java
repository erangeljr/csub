/*   Params.java                                                   
 *   Demonstrates 1) parameter passing in Java; 2) Java's huge footprint 
 *   Uses: Dog.java                                                
 *                                                                 
 */

import java.io.*;    
import java.util.List;
import java.util.LinkedList;

public class Params 
{
   public static void main (String[] args) throws IOException
   {
      Dog x; // you can do this, but x is not an object yet!
      x = new Dog("Xerox");
      Dog b = new Dog("Buster");
      x = b;  // java does not have a reference type - so x now points to b
      b.setName("bowwow");
      System.out.println ("x: " + x.getName() );    
      x.setName("fluffy");
      System.out.println ("b: " + b.getName() );    
 
      Dog c = new Dog("fido");  // all objects are allocated from the heap      
      foo(c);                                               // from foo:fifi
      System.out.println ("mainDog:" + c.getName() );       // mainDog: fido
      foo2(c);                                              // foo2:    spot
      System.out.println ("mainDog:" + c.getName() );       // mainDog: spot
      foo3(c);                                              // foo3:    buddy
      System.out.println ("mainDog:" + c.getName() );       // mainDog: spot

      /* do something to check java's footprint */
      System.out.println (fib(40));

   }   // end main

   public static void foo(Dog d) {
      d = new Dog("fifi");              // points local d to a new Dog object
      System.out.println ("foo:" + d.getName() );
   }

   public static void foo2(Dog d) {
      d.setName("spot");                // changes Dog name in caller
      System.out.println ("foo2:" + d.getName() );
   }
   public static void foo3(Dog d) {
   /* Java "pass-by-reference" behaves like C pointers NOT C++ references */
      Dog e = new Dog("buddy");
      d = e;                          // points local d to a new Dog object  
      System.out.println ("foo3:" + d.getName() ); // prints 
    }

   public static int fib(int n) {
      if (n == 0) return 0; 
      if (n == 1) return 1; 
      return fib(n-1) + fib(n-2);
   } 
}
/* uses
 *
 * public class Dog
 * {
 *   private String name;
 *
 *   public Dog ( String s)
 *   { name = s; }
 *
 *   public void setName (String s)
 *   { name = s; }
 *
 *   public String getName ()
 *   { return name; }
 *
 * }
 */
