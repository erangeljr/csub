# Phase II 
# create a cflat compiler from scan.l and parse.y

all:	cf  sample 

cf:	parse.y symtab.c scan.l
	yacc -d -v --debug parse.y
	lex scan.l
	gcc -o cf lex.yy.c y.tab.c symtab.c -lfl

# -t flag enables debugging
sample:		sample.l sample.y  
	yacc -d -t sample.y
	lex sample.l
	gcc -o sample y.tab.c symtab.c lex.yy.c -lfl

clean:
	$(RM) cf *.o  lex.yy.c  y.tab.c y.tab.h *.dump
