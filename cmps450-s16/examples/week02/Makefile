# makefile for week 2 examples

all:	counter sample1 dec-to-hex comments english numberit

sample1:	sample1.l
	flex sample1.l
	gcc -o sample1 lex.yy.c -lfl

counter:	counter.l
	flex counter.l
	gcc -o counter lex.yy.c -lfl

dec-to-hex:	dec-to-hex.l
	flex dec-to-hex.l
	gcc -o dec-to-hex lex.yy.c -lfl

comments:	comments.l
	flex comments.l
	gcc -o comments lex.yy.c -lfl

english:	english.l
	flex english.l
	gcc -o english lex.yy.c -lfl

numberit:	numberit.l
	flex numberit.l
	gcc -o numberit lex.yy.c -lfl

clean:
	rm -f counter sample1 lex.yy.c comments english numberit
