# create a scanner that demonstrates use of symbol table 

all:	scan sample

# use this rule to build your scanner
scan:	scan.l symtab.c
	lex scan.l
	gcc -c lex.yy.c 
	gcc -o scan symtab.c lex.yy.o -lfl 

# build sample scanner in phase I files that demos symbol table
sample:	sample.l symtab.c
	lex sample.l
	gcc -o sample symtab.c lex.yy.c -lfl 

clean:
	$(RM) scan sample *.o lex.yy.c 
