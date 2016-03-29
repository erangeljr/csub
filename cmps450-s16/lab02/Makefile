all:	lab02

lab02:	lab02.l
	flex lab02.l
	gcc -o lab02 lex.yy.c -lfl

clean:	
	rm -f lab02 lex.yy.c
