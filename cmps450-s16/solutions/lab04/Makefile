# Makefile for lab04 files

all:	concord lab04 
concord:
	flex -7 -T concord.l
	gcc -o concord lex.yy.c -lfl 

# -7 is 7-bit ascii tables; -T is dump tables; -d is debug mode
# flex -7 -T -d lab04.l
lab04: lab04.l
	flex -7 -T -d lab04.l
	gcc -o lab04 lex.yy.c 

dragon: dragon.l
	flex -7 -T -d dragon.l
	gcc -o dragon lex.yy.c 

clean:
	$(RM) concord dragon lab04 *.o lex.yy.c
