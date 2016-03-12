	.file	"binding.c"
	.globl	myGlobal
	.data
	.align 4
	.type	myGlobal, @object
	.size	myGlobal, 4
myGlobal:
	.long	88
	.align 4
	.type	myStatic, @object
	.size	myStatic, 4
myStatic:
	.long	77
	.text
	.globl	funcA
	.type	funcA, @function
funcA:
.LFB0:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movl	%edi, -20(%rbp)
	movl	$66, -4(%rbp)
	addl	$99, -4(%rbp)
	movl	$0, %eax
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE0:
	.size	funcA, .-funcA
	.globl	main
	.type	main, @function
main:
.LFB1:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movl	$55, -4(%rbp)
	movq	$97, -48(%rbp)
	movq	$0, -40(%rbp)
	movq	$0, -32(%rbp)
	movq	$0, -24(%rbp)
	movb	$0, -16(%rbp)
	movb	$98, -48(%rbp)
	movl	$0, %eax
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE1:
	.size	main, .-main
	.data
	.align 4
	.type	myStatic.1712, @object
	.size	myStatic.1712, 4
myStatic.1712:
	.long	44
	.ident	"GCC: (Debian 4.7.2-5) 4.7.2"
	.section	.note.GNU-stack,"",@progbits
