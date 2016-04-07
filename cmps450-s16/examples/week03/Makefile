# create sample from sample.l and sample.y
# if you use bison to compile then you must use -y flag to generate yacc names

default:
  # -d spits out y.tab.h   -t enables debugging
	yacc -d -t sample.y
	lex sample.l
	gcc -o sample lex.yy.c y.tab.c -lfl 

clean:
	$(RM) sample *.o *.c  *.h
