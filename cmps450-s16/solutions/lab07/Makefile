# create parser from lab07.l and lab07.y
# if you use bison instead of yacc you must use -y flag to generate yacc names

default:
	yacc -d -v --debug lab07.y
	lex -l lab07.l
	gcc -g -o lab07 symtab.c lex.yy.c y.tab.c
clean:
	$(RM) lab07 *.o lex.yy.c lab07.tab.c y.tab.h y.output dump.symtab
