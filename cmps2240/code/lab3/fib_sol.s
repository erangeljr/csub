# Fibonacci number calculator.
# Derived from:
# Factorial example from Appendix A, pp A-27 to A-29 (on CD)
#
.data
newline: .asciiz "\n"
usage_stmt:
         .asciiz   "\nUsage: spim -f fib.s < n >\n"
.text
.globl main    # Start execution at main
.ent main      # Entry point of main function
main:
  # The book makes use of frame pointers in this example.
  # As described on page A-27, by convention a frame is 24 bytes
  # to store a0 - a3 and ra. This includes 4 bytes of padding.
  # To save fp, another 8 bytes are added (4 for fp and 4 for 
  # padding), making the frame 32 bytes long. Even though a0-a3
  # are not saved to the stack, space is still reserved on the
  # stack for them.

  addi $sp, $sp, -32  # Stack frame is 32 bytes long
  sw   $ra, 20($sp)   # Save return address
  sw   $fp, 16($sp)   # Save old frame pointer
  addi $fp, $sp, 28   # point to first word in bottom of frame 

                      #--- code from gcd.s-----------
                      # grab command line stuff - a0 is arg count and a1 points to
                      # list of args
  move $s0, $a0
  move $s1, $a1
                      # zero out these registers just to be safe
  move $s2, $zero
  move $s3, $zero
  move $s4, $zero
                      # check if less than 2 arguments are given
  li $t0, 2 
  blt $a0, $t0, exit_on_error
                      # parse the first number
  lw $a0, 4($s1)
  jal atoi
  move $s2, $v0
                      #------------------------------
                      # With the return address and frame pointer saved, main()
                      # can now make all its needed function calls
  #li  $a0, 7         # Put argument (the number 7) in $a0
  move $a0, $s2       # Put argument in $a0
  jal  fib            # Call fibonacci function
  move $t0, $v0       # move result to t0

                      # display stuff now
  la $a0, msg         # address of msg
  li $v0, 4           # syscall 4=print string 
  syscall  
  move $a0, $t0       # Move fib result to $a0 to display it
  li   $v0, 1         # syscall 1=print int
  syscall  
  li  $a0, 10         # ascii LF char
  li  $v0, 11         # syscall 11=print char
  syscall
                      # Since the function calls are done, restore the
                      # return address and frame pointer.
  lw  $ra, 20($sp)    # Restore return address
  lw  $fp, 16($sp)    # Restore frame pointer
  addi  $sp, $sp, 32  # Pop stack frame
  li  $v0, 10         # 10 is the code for exiting
  syscall             # Execute the exit
.end main

exit_on_error:
  li $v0, 4
  la $a0, usage_stmt  # print usage_stmt statement and exit
  syscall
  li $v0, 10          # 10=exit
  syscall



.rdata   #read only data follows
msg:
.asciiz "The 7th fibonacci number is: "

  #------------------------------------------
  # int fib(int n) {
  #     if (n == 0)
  #         return 0;
  #     if (n == 1)
  #         return 1;
  #     return fib(n-1) + fib(n-2);
  # }
  #------------------------------------------

.text        # Another segment of instructions
.ent fib     # Entry point of the fib function
fib:
             # As above, create a 32 byte frame to store a0-a3, ra and fp.
             # For the fact procedure, a0 will be saved in offset 28 from the
             # sp (offset 0 from the fp).

  addi $sp, $sp, -32  # Stack frame is 32 bytes long
  sw   $ra, 20($sp)   # Save return address
  sw   $fp, 16($sp)   # Save frame pointer
  addi $fp, $sp, 28   # Set up frame pointer
  sw   $a0, 0($fp)    # Save argument (n)

  lw    $v0, 0($fp)   # Load n
  beqz  $v0, ret      # Branch if n == 0

  lw    $v0, 0($fp)   # Load n
  li    $t1, 1        # load immediately a 1 into $t1
  beq   $v0, $t1, ret # Branch if n == 1

rec:
  lw    $v1, 0($fp)   # Load n
  addi  $a0, $v1, -1  # Compute n - 1
  jal   fib           # recursive call to fibonacci function
  sw    $v0, 4($sp)   # store the result of jal fib

  lw    $v1, 0($fp)   # Load n
  addi  $a0, $v1, -2  # Compute n - 2
  jal   fib           # recursive call to factorial function

                      # return the sum of 2 calls above
  lw $s0, 4($sp)      # get 1st result from stack
  add $v0, $s0, $v0   # second result is in v0

ret:
  lw   $ra, 20($sp)  # Restore $ra
  lw   $fp, 16($sp)  # Restore frame pointer
  addi $sp, $sp, 32  # Pop stack frame
  jr   $ra           # Return to caller

.end fib

# --------- ATOI FUNCTION 
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
#----------------------------------------

