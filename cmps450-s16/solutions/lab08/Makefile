# makefile for lab08 

all:	lab08 

lab08:	lab08.y lab08.l
	yacc -d lab08.y
	lex lab08.l
	gcc -g -o lab08 lex.yy.c y.tab.c

clean:
	$(RM) lab08 *.o *.c  *.h
