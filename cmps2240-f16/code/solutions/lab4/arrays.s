# One solution to the lab-4 part-1 problem.
# filename: arrays.s
#
# 1. Declare an array to hold 30 integers.
# 2. Use a loop to initialize the array with the first 30 odd integers.
# 3. Display the values to the screen within the loop.
# 4. Uses a second loop to display only values evenly divisible by 3 or 7.   
#
# Register Usage:
# $t0  - pointer to array 

   .data
            #allocate 30 consecutive words aligned on word boundary
            #load 32-bit integer value 0 in each word
   array:   .word 0:30
   space:   .asciiz " "
   newline: .asciiz "\n"
   
   .text
   .globl main
   
main:
   la $t0, array
   li $t1, 1          # iterator (i)
   li $t5, 30         # count
   li $t2, 1          # the first odd number

fill:                 # for (i=1; i<=count; i++)
   sw $t2, ($t0)      # store value in t2 to array 
   addi $t0, 4        # add 4 bytes to the array address to point to next slot 
   addi $t2, 2        # next odd number
   addi $t1, 1        # i++
   ble $t1, $t5, fill # if t1 <= t5 continue looping

   jal prep_array
show:
   li $v0, 1          # load print_integer syscall
   lw $a0, ($t0)      # load value at array index 
   syscall
   li $v0, 4
   la $a0, space
   syscall
   addi $t0, 4
   addi $t1, 1
   ble $t1, $t5, show
   jal nl
   jal nl

   #---------------------------------------
   #display only values divisible by 3 or 7
   #---------------------------------------
   jal prep_array
show37:
   lw $a0, ($t0)      # load value at array index 
   li $t3, 3
   li $t7, 7
check3:               # check if divisible by 3
   div $a0, $t3
   mfhi $s1
   #if remainder not zero, move on
   bgtz $s1, check7
   li $v0, 1          # load print_integer syscall
   lw $a0, ($t0)      # load value at array index 
   syscall
   li $v0, 4
   la $a0, space
   syscall
   j next
check7:               # check if divisible by 7
   div $a0, $t7
   mfhi $s1
   bgtz $s1, next
   li $v0, 1          # load print_integer syscall
   lw $a0, ($t0)      # load value at array index 
   syscall
   li $v0, 4
   la $a0, space
   syscall
   #j next
next:
   addi $t0, 4
   addi $t1, 1
   ble $t1, $t5, show37
   jal nl
   j end

prep_array:
   # prepare to print the array
   la $t0, array      # load addr of array
   li $t1, 1          # i
   li $t5, 30         # count
   jr $ra

nl:
   # print a newline
   li $v0, 4
   la $a0, newline
   syscall
   jr $ra

end:
   li $v0, 10
   li $a0, 0
   syscall

