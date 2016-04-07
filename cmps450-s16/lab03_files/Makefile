# create calc from calc.l and calc.y
# if you use bison to compile then you must use -y flag to generate yacc names

default:
  # -d spits out y.tab.h   -t enables debugging
	yacc -d -t calc.y
	lex calc.l
	gcc -o calc lex.yy.c y.tab.c -lfl 
clean:
	$(RM) calc *.o *.c  *.h
