# create sdt from sdt.l and sdt.y
# if you use bison to compile then you must use -y flag to generate yacc names

default:
	yacc -d sdt.y
	lex sdt.l
	gcc -o sdt lex.yy.c y.tab.c -lfl
clean:
	$(RM) sdt *.o *.c  *.h *.out
