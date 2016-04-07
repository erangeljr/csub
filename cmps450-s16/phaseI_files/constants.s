	.file	"constants.c"
	.globl	myNum
	.data
	.align 4
	.type	myNum, @object
	.size	myNum, 4
myNum:
	.long	55
	.globl	myStr
	.type	myStr, @object
	.size	myStr, 10
myStr:
	.string	"hello"
	.zero	4
	.text
	.globl	main
	.type	main, @function
main:
.LFB0:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movl	$99, -4(%rbp)
	movabsq	$4620355447710076109, %rax
	movq	%rax, -16(%rbp)
	movl	$0, %eax
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE0:
	.size	main, .-main
	.ident	"GCC: (Debian 4.7.2-5) 4.7.2"
	.section	.note.GNU-stack,"",@progbits
