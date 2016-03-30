	.file	"simple.c"
	.global strLiteral
	.section	".data"
	.align 8
	.type	strLiteral, #object
	.size	strLiteral, 10
strLiteral:
	.asciz	"hello"
	.skip 4
	.global charLit
	.type	charLit, #object
	.size	charLit, 1
charLit:
	.byte	97
	.global floatConstant
	.align 8
	.type	floatConstant, #object
	.size	floatConstant, 8
floatConstant:
	.long	1075236044
	.long	-858993459
	.global intConstant
	.section	".rodata"
	.align 4
	.type	intConstant, #object
	.size	intConstant, 4
intConstant:
	.long	5
	.section	".text"
	.align 4
	.global main
	.type	main, #function
	.proc	04
main:
	!#PROLOGUE# 0
	save	%sp, -112, %sp
	!#PROLOGUE# 1
	mov	0, %g1
	mov	%g1, %i0
	ret
	restore
	.size	main, .-main
	.ident	"GCC: (GNU) 3.4.5"
