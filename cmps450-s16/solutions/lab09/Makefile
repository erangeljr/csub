# makefile for lab09

default: lab09.y lab09.l gencode.c defs.h
	yacc -d -v --debug lab09.y 
	lex lab09.l
	gcc -o lab09 lex.yy.c y.tab.c gencode.c 

clean:
	$(RM) lab09 *.o lex.yy.c y.tab.c y.tab.h
