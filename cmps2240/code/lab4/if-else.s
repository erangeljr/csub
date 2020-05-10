#  filename: if-else.s
#  purpose:  demonstrate use of if-else control structure; prompts for an
#  integer; displays whether the integer is even or odd.
#  
#       $ spim -f if-else.s 13  
#       $ 13 is odd.
#
#       $ spim -f if-else.s 14  
#       $ 14 is even.
#
# Cmdline args are accessed via an array of addresses (pointers) to strings. 
# A MIPS address is stored in a word (4 bytes). The first address in the array 
# (offset zero) points to the filename of the executable. The next address in 
# the array (offset 4) points to the first cmdline arg and so on. Since the args
# are read in as strings, if you expect a number you need to convert it.

    .data
errmsg:
    .asciiz   "\nUsage: spim -f if-else.s <int> \n\n"
isodd:
    .asciiz   " is odd."
iseven:
    .asciiz   " is even."
newline:
    .asciiz   "\n"
result:
    .space    11
    
.text
.globl main
     
main:
    ori  $t0, 0
    move $s0, $a0       # a0 holds the number of cmdline args
    move $s1, $a1       # a1 is the base pointer to the array of addresses 
    move $s2, $zero
    move $s3, $zero
    move $s4, $zero
     
                        # verify that one argument is given
    li $t0, 1 
    ble $a0, $t0, error
     
                        # parse the arg by loading its address (offset 4
                        # from the base of the array) into $a0 and then
                        # calling atoi to convert the string into an int
    lw $a0, 4($s1)       
    jal atoi
    move $s2, $v0
     
                           # test whether integer is odd or even by dividing
                           # by 2 and checking the value of the remainder in
                           # hi register (quotient is in lo)
                           # divide int by 2
    li $s3, 2
    div $s2, $s3           # divide command line argument in $s2 by 2
    mfhi $s4               # move remainder into $s4
    beq $zero, $s4, even   # if ($s4 == 0) then arg is even 
    bne $zero, $s4, odd    # else if ($s4 != 0) then arg is odd 

odd: 
                           # print the result
    li $v0, 1              # print_int syscall 
    move $a0, $s2
    syscall
    li $v0, 4              # print_string syscall
    la $a0, isodd 
    syscall
    la $a0, newline
    syscall
    b exit                 # you need this branch otherwise you execute the
                           # next instruction 
even: 
                           # print the result
    li $v0, 1              # print_int syscall 
    move $a0, $s2
    syscall
    li $v0, 4
    la $a0, iseven 
    syscall
    la $a0, newline
    syscall
    b exit                 # you need this branch otherwise you continue with
                           # next code
error:
                           # print error message
    li $v0, 4
    la $a0, errmsg
    syscall

exit:
    li $v0, 10
    li $a0, 0
    syscall
     
atoi:
    move $v0, $zero
                           # detect sign
    li $t0, 1
    lbu $t1, 0($a0)
    bne $t1, 45, digit
    li $t0, -1
    addu $a0, $a0, 1
digit:
                           # read character
    lbu $t1, 0($a0)
                           # finish when non-digit encountered
    bltu $t1, 48, finish
    bgtu $t1, 57, finish
                           # translate character into digit
    subu $t1, $t1, 48
                           # multiply the accumulator by ten
    li $t2, 10
    mult $v0, $t2
    mflo $v0
                           # add digit to the accumulator
    add $v0, $v0, $t1
                           # next character
    addu $a0, $a0, 1
    b digit
finish:
    mult $v0, $t0
    mflo $v0
    jr $ra

