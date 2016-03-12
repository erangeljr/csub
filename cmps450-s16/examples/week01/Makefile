# Makefile for week01 examples

all:	dog Dog params-java binding params-cpp scope1 scope2 scope

dog:	dog.cpp
	g++ -o dog dog.cpp

Dog:	Dog.java
	javac Dog.java

params-java:	Params.java
	javac Params.java

binding:	binding.c
	gcc -S binding.c
	gcc -o binding binding.c

params-cpp:	 params-cpp.cpp
	g++ -o params-cpp params-cpp.cpp

# create scope1.o
scope1: scope1.c
	gcc -c scope1.c

# create scope2.o
scope2:	scope2.c
	gcc -c scope2.c

# link scope1.o scope2.o
scope:	scope1.o scope2.o
	gcc -o scope scope1.o scope2.o

clean:
	rm *.o  a.out
	rm *.class
	rm dog scope2 scope1 binding params-cpp
