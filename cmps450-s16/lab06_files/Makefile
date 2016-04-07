# Makefile for cmps 450 lab06
# create lab from lab06.l and lab06.y
# if you use bison command then you must use -y flag to generate yacc names

all:	lab06

lab06:  lab06.l lab06.y lab06.h
	yacc -d -v --debug lab06.y
	lex -l lab06.l
	gcc -o lab06 symtab.c lex.yy.c y.tab.c

clean:
	$(RM) lab06 *.o lex.yy.c lab06.tab.c y.tab.h y.output dump.symtab log
