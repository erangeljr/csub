	.file	"scope2.c"
	.data
	.align 4
	.type	static_var, @object
	.size	static_var, 4
static_var:
	.long	20
	.text
	.globl	funa
	.type	funa, @function
funa:
.LFB0:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movl	$99, GLOBAL(%rip)
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE0:
	.size	funa, .-funa
	.ident	"GCC: (Debian 4.7.2-5) 4.7.2"
	.section	.note.GNU-stack,"",@progbits
