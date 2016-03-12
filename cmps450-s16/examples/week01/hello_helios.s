	.file	"hello.c"
	.section	".rodata"
	.align 8
.LLC0:
	.asciz	"hello"
	.section	".text"
	.align 4
	.global main
	.type	main, #function
	.proc	04
main:
	!#PROLOGUE# 0
	save	%sp, -112, %sp
	!#PROLOGUE# 1
	mov	1, %o0
	sethi	%hi(.LLC0), %g1
	or	%g1, %lo(.LLC0), %o1
	mov	5, %o2
	call	write, 0
	 nop
	mov	0, %g1
	mov	%g1, %i0
	ret
	restore
	.size	main, .-main
	.ident	"GCC: (GNU) 3.4.5"
