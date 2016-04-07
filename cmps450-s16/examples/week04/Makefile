# create lab04 files
# -T option produces a description of the generated scanner in l.output 
# -7 flag creates 7-bit char rather than 8-bit char tables to reduce table size

all:	astar wc lab04a  vowels

astar:
	flex -7 -T astar.l
	gcc -o astar lex.yy.c -lfl 

vowels:
	flex -7 -T vowels.l
	gcc -o vowels lex.yy.c -lfl 

wc:
	flex -7 -T wc.l
	gcc -o wc lex.yy.c -lfl 

lab04a:
	flex -7 -T -d lab04a.l
	gcc -o lab04a lex.yy.c -lfl 

clean:
	$(RM) vowels astar wc lab04 lab04a *.o lex.yy.c
