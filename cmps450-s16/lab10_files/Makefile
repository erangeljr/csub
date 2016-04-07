default:
	yacc -d -v --debug parse.y
	lex -l scan.l
	gcc -g -o tc main.c tree.c symtab.c analyze.c gencode.c lex.yy.c y.tab.c
clean:
	$(RM) tc *.o lex.yy.c y.tab.c y.tab.h y.output 

