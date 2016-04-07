# Makefile for cmps 450 lab05
# create lab05 from lab05.l and lab05.y
# if you use bison command then you must use -y flag to generate yacc names

default:
	yacc -d -v --debug lab05.y
	lex -l lab05.l
	gcc -o lab05 symtab.c lex.yy.c y.tab.c
clean:
	$(RM) lab05 *.o lex.yy.c y.tab.c y.tab.h y.output lab05.tab.c *.dump 
