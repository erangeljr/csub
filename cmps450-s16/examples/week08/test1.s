	.file	"test1.c"
	.globl	globInt
	.data
	.align 4
	.type	globInt, @object
	.size	globInt, 4
globInt:
	.long	55
	.globl	globFloat
	.align 4
	.type	globFloat, @object
	.size	globFloat, 4
globFloat:
	.long	1085276160
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
	movl	%edi, -20(%rbp)
	movss	%xmm0, -24(%rbp)
	movl	$77, globInt(%rip)
	movl	.LC0(%rip), %eax
	movl	%eax, -4(%rbp)
	movl	.LC1(%rip), %eax
	movl	%eax, globFloat(%rip)
	movl	$1, %eax
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE0:
	.size	main, .-main
	.section	.rodata
	.align 4
.LC0:
	.long	1113456640
	.align 4
.LC1:
	.long	1120298598
	.ident	"GCC: (Debian 4.7.2-5) 4.7.2"
	.section	.note.GNU-stack,"",@progbits
