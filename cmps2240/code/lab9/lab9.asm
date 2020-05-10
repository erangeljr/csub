; lab9.asm
; CMPS 2240 
; author: Eddie Rangel
;
; Programming challenge
;
; Goal: fewest lines of code
;       1. top line must be a comment with student names.
;       2. program functionality must be same as original.
;
;
; 
; Prompt the user to enter 10 numbers, then display the sum
; of the numbers entered.
;
; To assemble and link:
;
;     $ nasm -f elf64 lab10.asm
;     $ gcc -o lab10 lab10.o   # use gcc so glibc will be linked in
;
; OR you could link manually with this:
; $ ld -dynamic-linker /lib64/ld-linux-x86-64.so.2 /usr/lib64/crt1.o \
;        /usr/lib64/crti.o lab10.o  /usr/lib64/crtn.o -lc -o lab10

section .rodata
	prompt1    db "Please enter a number: ",0   ; 0 is null character
	prompt2    db "Enter another number: ",0
	format_str db "The sum is: %ld.",10,0  ; 10 is LF 
	num_format db "%ld",0

section .text
	global main              ; main and _start are both valid entry points
	extern printf, scanf     ; these will be linked in from glibc 

main:
	; prologue
	push    rbp          ; save base pointer to the stack
	mov     rbp, rsp     ; base pointer = stack pointer 
	sub     rsp, 80      ; make room for integers on the stack
	push    rbx          ; push callee saved registers onto the stack 
	push    r12          ; push automatically decrements stack pointer
	push    r13          
	push    r14
	push    r15
	pushfq               ; push register flags onto the stack

	; prompt for first integer 
	mov    rdi, dword prompt1    ; double word is 4 bytes; a word is 2 bytes
	xor    rax, rax              ; rax is return value register - zero it out
	call   printf                ; call the C function from glibc 
	lea    rsi, [rbp-8]          ; load effective address - this instruction
	mov    rdi, dword num_format ; load rdi with address to format string
	xor    rax, rax              ; zero out return value register
	call   scanf                 ; call C function
                                 ; scanf reads the input as an integer

	; prompt for other integer
	mov    rdi, dword prompt2
	xor    rax, rax
	call   printf
	lea    rsi, [rbp-16]         ; read number 
	mov    rdi, dword num_format
	xor    rax, rax
	call   scanf

	; prompt for other integer
	mov    rdi, dword prompt2
	xor    rax, rax
	call   printf
	lea    rsi, [rbp-24]         ; read number 
	mov    rdi, dword num_format
	xor    rax, rax
	call   scanf

	; prompt for other integer
	mov    rdi, dword prompt2
	xor    rax, rax
	call   printf
	lea    rsi, [rbp-32]         ; read number 
	mov    rdi, dword num_format
	xor    rax, rax
	call   scanf

	; prompt for other integer
	mov    rdi, dword prompt2
	xor    rax, rax
	call   printf
	lea    rsi, [rbp-40]         ; read number 
	mov    rdi, dword num_format
	xor    rax, rax
	call   scanf

	; prompt for other integer
	mov    rdi, dword prompt2
	xor    rax, rax
	call   printf
	lea    rsi, [rbp-48]         ; read number 
	mov    rdi, dword num_format
	xor    rax, rax
	call   scanf

	; prompt for other integer
	mov    rdi, dword prompt2
	xor    rax, rax
	call   printf
	lea    rsi, [rbp-56]         ; read number 
	mov    rdi, dword num_format
	xor    rax, rax
	call   scanf

	; prompt for other integer
	mov    rdi, dword prompt2
	xor    rax, rax
	call   printf
	lea    rsi, [rbp-64]         ; read number 
	mov    rdi, dword num_format
	xor    rax, rax
	call   scanf

	; prompt for other integer
	mov    rdi, dword prompt2
	xor    rax, rax
	call   printf
	lea    rsi, [rbp-72]         ; read number 
	mov    rdi, dword num_format
	xor    rax, rax
	call   scanf

	; prompt for other integer
	mov    rdi, dword prompt2
	xor    rax, rax
	call   printf
	lea    rsi, [rbp-80]         ; read number 
	mov    rdi, dword num_format
	xor    rax, rax
	call   scanf

	                        ; add all numbers together
	xor rbx, rbx            ; sum = 0
	mov rcx, [rbp-8]        ; RBX = number
	add rbx, rcx            ; add num + num - store in rbx
	mov rcx, [rbp-16]       ; RBX = number
	add rbx, rcx            ; add num + num - store in rbx
	mov rcx, [rbp-24]       ; RBX = number
	add rbx, rcx            ; add num + num - store in rbx
	mov rcx, [rbp-32]       ; RBX = number
	add rbx, rcx            ; add num + num - store in rbx
	mov rcx, [rbp-40]       ; RBX = number
	add rbx, rcx            ; add num + num - store in rbx
	mov rcx, [rbp-48]       ; RBX = number
	add rbx, rcx            ; add num + num - store in rbx
	mov rcx, [rbp-56]       ; RBX = number
	add rbx, rcx            ; add num + num - store in rbx
	mov rcx, [rbp-64]       ; RBX = number
	add rbx, rcx            ; add num + num - store in rbx
	mov rcx, [rbp-72]       ; RBX = number
	add rbx, rcx            ; add num + num - store in rbx
	mov rcx, [rbp-80]       ; RBX = number
	add rbx, rcx            ; add num + num - store in rbx
	mov rsi, rbx
	mov rdi, dword format_str
	xor rax, rax            ; rax is return value register - zero it out
	call printf             ; call the C function from glibc 
exit:
      ; epilogue
      popfq
      pop     r15
      pop     r14
      pop     r13
      pop     r12
      pop     rbx
      add     rsp, 80       ; set back the stack level
      leave
      ret
				
