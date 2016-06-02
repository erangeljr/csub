	.file	"symtab.c"
	.text
	.type	hash, @function
hash:
.LFB5:
	pushq	%rbp
.LCFI0:
	movq	%rsp, %rbp
.LCFI1:
	pushq	%rbx
.LCFI2:
	movq	%rdi, -32(%rbp)
	movl	$0, -16(%rbp)
	movl	$0, -12(%rbp)
	jmp	.L2
.L3:
	movl	-16(%rbp), %eax
	movl	%eax, %edx
	sall	$4, %edx
	movl	-12(%rbp), %eax
	cltq
	addq	-32(%rbp), %rax
	movzbl	(%rax), %eax
	movsbl	%al,%eax
	leal	(%rdx,%rax), %ecx
	movl	$81421181, -36(%rbp)
	movl	-36(%rbp), %eax
	imull	%ecx
	sarl	$2, %edx
	movl	%ecx, %eax
	sarl	$31, %eax
	movl	%edx, %ebx
	subl	%eax, %ebx
	movl	%ebx, %eax
	movl	%eax, -16(%rbp)
	movl	-16(%rbp), %eax
	imull	$211, %eax, %eax
	movl	%ecx, %edx
	subl	%eax, %edx
	movl	%edx, %eax
	movl	%eax, -16(%rbp)
	incl	-12(%rbp)
.L2:
	movl	-12(%rbp), %eax
	cltq
	addq	-32(%rbp), %rax
	movzbl	(%rax), %eax
	testb	%al, %al
	jne	.L3
	movl	-16(%rbp), %eax
	popq	%rbx
	leave
	ret
.LFE5:
	.size	hash, .-hash
.globl st_insert
	.type	st_insert, @function
st_insert:
.LFB6:
	pushq	%rbp
.LCFI3:
	movq	%rsp, %rbp
.LCFI4:
	subq	$48, %rsp
.LCFI5:
	movq	%rdi, -40(%rbp)
	movl	%esi, -44(%rbp)
	movl	%edx, -48(%rbp)
	movq	-40(%rbp), %rdi
	call	hash
	movl	%eax, -20(%rbp)
	movl	-20(%rbp), %eax
	cltq
	movq	hashTable(,%rax,8), %rax
	movq	%rax, -16(%rbp)
	jmp	.L7
.L8:
	movq	-16(%rbp), %rax
	movq	24(%rax), %rax
	movq	%rax, -16(%rbp)
.L7:
	cmpq	$0, -16(%rbp)
	je	.L9
	movq	-16(%rbp), %rax
	movq	(%rax), %rsi
	movq	-40(%rbp), %rdi
	call	strcmp
	testl	%eax, %eax
	jne	.L8
.L9:
	cmpq	$0, -16(%rbp)
	jne	.L11
	movl	$32, %edi
	call	malloc
	movq	%rax, -16(%rbp)
	movq	-16(%rbp), %rdx
	movq	-40(%rbp), %rax
	movq	%rax, (%rdx)
	movl	$16, %edi
	call	malloc
	movq	%rax, %rdx
	movq	-16(%rbp), %rax
	movq	%rdx, 8(%rax)
	movq	-16(%rbp), %rax
	movq	8(%rax), %rdx
	movl	-44(%rbp), %eax
	movl	%eax, (%rdx)
	movq	-16(%rbp), %rdx
	movl	-48(%rbp), %eax
	movl	%eax, 16(%rdx)
	movq	-16(%rbp), %rax
	movq	8(%rax), %rax
	movq	$0, 8(%rax)
	movl	-20(%rbp), %eax
	cltq
	movq	hashTable(,%rax,8), %rdx
	movq	-16(%rbp), %rax
	movq	%rdx, 24(%rax)
	movl	-20(%rbp), %eax
	movslq	%eax,%rdx
	movq	-16(%rbp), %rax
	movq	%rax, hashTable(,%rdx,8)
	jmp	.L17
.L11:
	movq	-16(%rbp), %rax
	movq	8(%rax), %rax
	movq	%rax, -8(%rbp)
	jmp	.L14
.L15:
	movq	-8(%rbp), %rax
	movq	8(%rax), %rax
	movq	%rax, -8(%rbp)
.L14:
	movq	-8(%rbp), %rax
	movq	8(%rax), %rax
	testq	%rax, %rax
	jne	.L15
	movl	$16, %edi
	call	malloc
	movq	%rax, %rdx
	movq	-8(%rbp), %rax
	movq	%rdx, 8(%rax)
	movq	-8(%rbp), %rax
	movq	8(%rax), %rdx
	movl	-44(%rbp), %eax
	movl	%eax, (%rdx)
	movq	-8(%rbp), %rax
	movq	8(%rax), %rax
	movq	$0, 8(%rax)
.L17:
	leave
	ret
.LFE6:
	.size	st_insert, .-st_insert
.globl st_lookup
	.type	st_lookup, @function
st_lookup:
.LFB7:
	pushq	%rbp
.LCFI6:
	movq	%rsp, %rbp
.LCFI7:
	subq	$32, %rsp
.LCFI8:
	movq	%rdi, -24(%rbp)
	movq	-24(%rbp), %rdi
	call	hash
	movl	%eax, -12(%rbp)
	movl	-12(%rbp), %eax
	cltq
	movq	hashTable(,%rax,8), %rax
	movq	%rax, -8(%rbp)
	jmp	.L19
.L20:
	movq	-8(%rbp), %rax
	movq	24(%rax), %rax
	movq	%rax, -8(%rbp)
.L19:
	cmpq	$0, -8(%rbp)
	je	.L21
	movq	-8(%rbp), %rax
	movq	(%rax), %rsi
	movq	-24(%rbp), %rdi
	call	strcmp
	testl	%eax, %eax
	jne	.L20
.L21:
	cmpq	$0, -8(%rbp)
	jne	.L23
	movl	$-1, -28(%rbp)
	jmp	.L25
.L23:
	movq	-8(%rbp), %rax
	movl	16(%rax), %eax
	movl	%eax, -28(%rbp)
.L25:
	movl	-28(%rbp), %eax
	leave
	ret
.LFE7:
	.size	st_lookup, .-st_lookup
	.section	.rodata
	.align 8
.LC0:
	.string	"Variable Name  Location   Line Numbers\n"
	.align 8
.LC1:
	.string	"-------------  --------   ------------\n"
.LC2:
	.string	"%-14s "
.LC3:
	.string	"%-8d  "
.LC4:
	.string	"%4d "
	.text
.globl printSymTab
	.type	printSymTab, @function
printSymTab:
.LFB8:
	pushq	%rbp
.LCFI9:
	movq	%rsp, %rbp
.LCFI10:
	subq	$48, %rsp
.LCFI11:
	movq	%rdi, -40(%rbp)
	movq	-40(%rbp), %rcx
	movl	$39, %edx
	movl	$1, %esi
	movl	$.LC0, %edi
	call	fwrite
	movq	-40(%rbp), %rcx
	movl	$39, %edx
	movl	$1, %esi
	movl	$.LC1, %edi
	call	fwrite
	movl	$0, -20(%rbp)
	jmp	.L28
.L29:
	movl	-20(%rbp), %eax
	cltq
	movq	hashTable(,%rax,8), %rax
	testq	%rax, %rax
	je	.L30
	movl	-20(%rbp), %eax
	cltq
	movq	hashTable(,%rax,8), %rax
	movq	%rax, -16(%rbp)
	jmp	.L32
.L33:
	movq	-16(%rbp), %rax
	movq	8(%rax), %rax
	movq	%rax, -8(%rbp)
	movq	-16(%rbp), %rax
	movq	(%rax), %rdx
	movq	-40(%rbp), %rdi
	movl	$.LC2, %esi
	movl	$0, %eax
	call	fprintf
	movq	-16(%rbp), %rax
	movl	16(%rax), %edx
	movq	-40(%rbp), %rdi
	movl	$.LC3, %esi
	movl	$0, %eax
	call	fprintf
	jmp	.L34
.L35:
	movq	-8(%rbp), %rax
	movl	(%rax), %edx
	movq	-40(%rbp), %rdi
	movl	$.LC4, %esi
	movl	$0, %eax
	call	fprintf
	movq	-8(%rbp), %rax
	movq	8(%rax), %rax
	movq	%rax, -8(%rbp)
.L34:
	cmpq	$0, -8(%rbp)
	jne	.L35
	movq	-40(%rbp), %rsi
	movl	$10, %edi
	call	fputc
	movq	-16(%rbp), %rax
	movq	24(%rax), %rax
	movq	%rax, -16(%rbp)
.L32:
	cmpq	$0, -16(%rbp)
	jne	.L33
.L30:
	incl	-20(%rbp)
.L28:
	cmpl	$210, -20(%rbp)
	jle	.L29
	leave
	ret
.LFE8:
	.size	printSymTab, .-printSymTab
	.local	hashTable
	.comm	hashTable,1688,32
	.section	.eh_frame,"a",@progbits
.Lframe1:
	.long	.LECIE1-.LSCIE1
.LSCIE1:
	.long	0x0
	.byte	0x1
	.string	"zR"
	.uleb128 0x1
	.sleb128 -8
	.byte	0x10
	.uleb128 0x1
	.byte	0x3
	.byte	0xc
	.uleb128 0x7
	.uleb128 0x8
	.byte	0x90
	.uleb128 0x1
	.align 8
.LECIE1:
.LSFDE1:
	.long	.LEFDE1-.LASFDE1
.LASFDE1:
	.long	.LASFDE1-.Lframe1
	.long	.LFB5
	.long	.LFE5-.LFB5
	.uleb128 0x0
	.byte	0x4
	.long	.LCFI0-.LFB5
	.byte	0xe
	.uleb128 0x10
	.byte	0x86
	.uleb128 0x2
	.byte	0x4
	.long	.LCFI1-.LCFI0
	.byte	0xd
	.uleb128 0x6
	.byte	0x4
	.long	.LCFI2-.LCFI1
	.byte	0x83
	.uleb128 0x3
	.align 8
.LEFDE1:
.LSFDE3:
	.long	.LEFDE3-.LASFDE3
.LASFDE3:
	.long	.LASFDE3-.Lframe1
	.long	.LFB6
	.long	.LFE6-.LFB6
	.uleb128 0x0
	.byte	0x4
	.long	.LCFI3-.LFB6
	.byte	0xe
	.uleb128 0x10
	.byte	0x86
	.uleb128 0x2
	.byte	0x4
	.long	.LCFI4-.LCFI3
	.byte	0xd
	.uleb128 0x6
	.align 8
.LEFDE3:
.LSFDE5:
	.long	.LEFDE5-.LASFDE5
.LASFDE5:
	.long	.LASFDE5-.Lframe1
	.long	.LFB7
	.long	.LFE7-.LFB7
	.uleb128 0x0
	.byte	0x4
	.long	.LCFI6-.LFB7
	.byte	0xe
	.uleb128 0x10
	.byte	0x86
	.uleb128 0x2
	.byte	0x4
	.long	.LCFI7-.LCFI6
	.byte	0xd
	.uleb128 0x6
	.align 8
.LEFDE5:
.LSFDE7:
	.long	.LEFDE7-.LASFDE7
.LASFDE7:
	.long	.LASFDE7-.Lframe1
	.long	.LFB8
	.long	.LFE8-.LFB8
	.uleb128 0x0
	.byte	0x4
	.long	.LCFI9-.LFB8
	.byte	0xe
	.uleb128 0x10
	.byte	0x86
	.uleb128 0x2
	.byte	0x4
	.long	.LCFI10-.LCFI9
	.byte	0xd
	.uleb128 0x6
	.align 8
.LEFDE7:
	.ident	"GCC: (GNU) 4.1.2 20061115 (prerelease) (Debian 4.1.1-21)"
	.section	.note.GNU-stack,"",@progbits
