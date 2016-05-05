# create calc from scan.l and parse.y
# if you use bison command then you must use -y flag to generate yacc names

default:
	yacc -d calc.y
	lex -l calc.l
	gcc -o calc lex.yy.c y.tab.c -lm
clean:
	$(RM) calc *.o lex.yy.c y.tab.c *.h
