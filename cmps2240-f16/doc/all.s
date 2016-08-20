# all.s
# Try all mips instructions in this one program.
# This program doesn't do anything useful except try all mips commands.

		.data
mess1:	.asciiz "Starting...\n"
mess2:	.asciiz "Ending.\n"
hello:	.asciiz "Hello there.\n"
var:	.word 1

	.text
main:
	la $a0, mess1
	li $v0, 4			# 4 print a string
	syscall				# execute the call 

	addi $t0, $zero, 0
	addi $t1, $zero, 1
	addi $t2, $zero, 2
	addi $t3, $zero, 3

#------------------------------------------------------------------------------
# Test of all instructions starts here
#------------------------------------------------------------------------------
	add $t0, $t1, $t2	#$d = $s + $t       Add with overflow
	addu $t0, $t1, $t2	#$d = $s + $t       Add unsigned
	addi $t0, $t1, 5	#$d = $s + se(i)	Add immediate
	addiu $t0, $t1, 5	#$d = $s + se(i)	Add immediate unsigned

	and $t1, $t2, $t3	#$d = $s & $t       Bitwise logical AND
	andi $t1, $t2, 5	#$t = $s & ze(i)    Bitwise logical AND imm

	div $t1, $t0		#lo=$s/$t; hi=$s%$t Divide
	divu $t1, $t0		#lo=$s/$t; hi=$s%$t Divide unsigned
	mult $t0, $t1		#hi:lo = $s * $t    Multiply
	multu $t0, $t1		#hi:lo = $s * $t    Multiply unsigned

	nor $t0, $t1, $t2	#$d = ~($s | $t)    Bitwise logical NOR
	or $t0, $t1, $t2	#$d = $s | $t       Bitwise logical OR
	ori $t0, $t1, 5		#$t = $s | ze(i)    Bitwise logical OR imm

	sll $t0, $t1, 1		#$d = $t << a       Shift left logical, a bits
	sllv $t0, $t1, $t2	#$d = $t << $s      Shift left logical, $s bits
	sra $t0, $t1, 1		#$d = $t >> a       Shift right arithmetic, a bits
	srav $t0, $t1, $t2	#$d = $t >> $s      Shift right arithmetic, $s bits
	srl $t0, $t1, 1		#$d = $t >>> a      Shift right logical, a bits
	srlv $t0, $t1, $t2	#$d = $t >>> $s     Shift right logical, $s bits

	sub $t0, $t1, $t2	#$d = $s - $t       Subtract
	subu $t0, $t1, $t2	#$d = $s - $t       Subtract unsigned

	xor $t0, $t1, $t2	#$d = $s ^ $t       Exclusive OR
	xori $t0, $t1, 1	#$d = $s ^ ze(i)    Exclusive OR immediate 

	slt $t0, $t1, $t2	# $d = ($s < $t)    Set on less than
	sltu $t0, $t1, $t2	# $d = ($s < $t)    Set on less than, unsigned
	slti $t0, $t1, 1	# $t = ($s < se(i)) Set on less than, immediate
	sltiu $t0, $t1, 1	# $t = ($s < se(i)) Set on less than, both

	beq $t0, $t1, l1	# if ($s==$t) pc+=i<<2 Branch if equal
l1:
	bgtz $t0, l2		# if ($s>0) pc+=i<<2   Branch if > zero
l2:
	blez $t0, l3		# if ($s<=0) pc+=i<<2  Branch if <= zero
l3:
	bne $t0, $t1, l4	# if ($s!=$t) pc+=i<<2 Branch if not equal
l4:
	j l5				# pc += i << 2         Jump
l5:
	jal func			# $31 = pc; pc+=i<<2   Jump and link
l6:
	la $t4, func
	jalr $t4			# $31 = pc; pc = $s    Jump and link, register

	lb $t0, 0 ($sp)		# $t=se (mem[$s+i]:1)  Load byte
	lbu $t0, 0 ($sp)	# $t=ze (mem[$s+i]:1)  Load byte unsigned
	lh $t0, 0 ($sp)		# $t=se (mem[$s+i]:2)  Load halfword
	lhu $t0, 0 ($sp)	# $t=ze (mem[$s+i]:2)  Load halfword unsigned
	lw $t0, 0 ($sp)		# $t= i mem[$s+i]:4    Load word
	lui $t0, 1			# $t = i<<16           Load i into upper halfword

	la $t4, var
	sb $t0, 0($t4)		# mem[$s+i]:1=LB($t)   Store byte
	sh $t0, 0($t4)		# mem[$s+i]:2=LH($t)   Store halfword
	sw $t0, 0($t4)		# mem[$s+i]:4=$t       Store word

	mfhi $t0			# $d = hi  Move from high
	mflo $t0			# $d = lo  Move from low
	mthi $t0			# hi = $s  Move to hi
	mtlo $t0			# lo = $s  Move to low 

#------------------------------------------------------------------------------
# Test of macro instructions starts here
#------------------------------------------------------------------------------

	abs $t0, $t1		#Absolute Value:3/3
	beqz $t0, m0		#Branch if Equal to Zero:1/1
m0:
	bge $t0, $t1, m1	#Branch if Greater Than or Equal:2/2
m1:
	bgeu $t0, $t1, m2	#Branch if Greater Than or Equal Unsigned:2/2
m2:
	bgt $t0, $t1, m3	#Branch if Greater Than:2/2
m3:
	bgtu $t0, $t1, m4	#Branch if Greater Than Unsigned:2/2
m4:
	ble $t0, $t1, m5	#Branch if Less Than or Equal:2/2
m5:
	bleu $t0, $t1, m6	#Branch if Less Than or Equal Unsigned:2/2
m6:
	blt $t0, $t1, m7	#Branch if Less Than:2/2
m7:
	bltu $t0, $t1, m8	#Branch if Less Than Unsigned:2/2
m8:
	bnez $t0, m9		#Branch if Not Equal to Zero:1/1
m9:
	b m10				#Branch Unconditional:1/1
m10:
	div $t0, $t1, $t2	#Divide:4/41
	divu $t0, $t1, $t2	#Divide Unsigned:4/41
	la $t0, end			#Load Address:2/2
	li $t0, 1			#Load Immediate:2/2
	move $t0,$t1		#Move:1/1
	mul $t0, $t1, $t2	#Multiply:2/33
	mulo $t0, $t1, $t2	#Multiply (with overflow exception):7/37
	mulou $t0, $t1, $t2 #Multiply Unsigned (with overflow exception):5/35
	neg $t0, $t1		#Negate:1/1
	negu $t0, $t1		#Negate Unsigned:1/1
	nop					#No operation:1/1
	not $t0, $t1		#Not:1/1
	remu $t0, $t1, $t2	#Remainder Unsigned:4/40
	rol $t0, $t1, $t2	#Rotate Left Variable:4/4
	ror $t0, $t1, $t2	#Rotate Right Variable:4/4
	rem $t0, $t1, $t2	#Remainder:4/40
	rol $t0, $t1, 1		#Rotate Left Constant:3/3
	ror $t0, $t1, 1		#Rotate Right Constant:3/3
	seq $t0, $t1, $t2	#Set if Equal:4/4
	sge $t0, $t1, $t2	#Set if Greater Than or Equal:4/4
	sgeu $t0, $t1, $t2	#Set if Greater Than or Equal Unsigned:4/4
	sgt $t0, $t1, $t2	#Set if Greater Than:1/1
	sgtu $t0, $t1, $t2	#Set if Greater Than Unsigned:1/1
	sle $t0, $t1, $t2	#Set if Less Than or Equal:4/4
	sleu $t0, $t1, $t2	#Set if Less Than or Equal Unsigned:4/4
	sne $t0, $t1, $t2	#Set if Not Equal:4/4
	la $t4, var
	ulh $t0, 0($t4)		#Unaligned Load Halfword Unsigned:4/4
	ulhu $t0, 0($t4)	#Unaligned Load Halfword:4/4
	ulw $t0, 0($t4)		#Unaligned Load Word:2/2
	ush $t0, 0($t4)		#Unaligned Store Halfword:3/3
	usw $t0, 0($t4)		#Unaligned Store Word:2/2 

end:
	la $a0, mess2
	li $v0, 4			# 4 print a string
	syscall				# execute the call 
	li $v0, 10			# 10 is system call to exit
	syscall				# execute the call 

func:
	#jr labelR			# pc = $s	Jump to address in register
	jr $ra



