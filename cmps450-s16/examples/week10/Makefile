# makes calculator for week 10 example files 
# demonstrates the use of an abstract syntax tree
#
default:
				yacc -d calc.y
				flex calc.l
				cc -o calc y.tab.c lex.yy.c calc.c
