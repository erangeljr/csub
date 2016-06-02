COMPILE = gcc -o cfc
CFLAGS = -lfl -pedantic
CFLAGS_DEBUG = -Wall -Wextra

compiler: parser scanner
	$(COMPILE) symtab.c scan.c parse.tab.c $(CFLAGS)

debug: parser scanner
	$(COMPILE) symtab.c scan.c parse.tab.c $(CFLAGS) $(CFLAGS_DEBUG)

parser: parse.y symtab.c symtab.h
	bison -d -v --debug parse.y

scanner lexer: scan.l symtab.c symtab.h
	flex -oscan.c -l scan.l

tar: compiler
	tar -cjf bhinesley_phase2.tar.bz2 scan.l parse.y symtab.h symtab.c Makefile

clean:
	$(RM) cfc *.o scan.c parse.tab.c parse.tab.h parse.output dump.symtab bhinesley_phase2.tar.bz2
