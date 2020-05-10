# create hw04 from hw04.l 

default:
	flex -7 -T -d hw04.l
	gcc -o hw04 lex.yy.c -lfl 

clean:
	$(RM) hw04 *.o lex.yy.c
