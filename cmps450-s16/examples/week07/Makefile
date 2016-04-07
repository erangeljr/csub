# create parser from grammarG.l and grammarG.y
# if you use bison instead of yacc you must use -y flag to generate yacc names

default:
	yacc -d -v --debug grammarG.y
	lex -l grammarG.l
	gcc -g -o grammarG symtab.c lex.yy.c y.tab.c
clean:
	$(RM) grammarG *.o lex.yy.c grammarG.tab.c y.tab.h y.output dump.symtab
