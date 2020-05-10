# gcd.s
# implementation of greatest common divisor

main:
  li $a0, 2323    # gcd of these 2 numbers 
  li $a1, 1111    #
  jal gcd
  move $t0, $v0
  move $a0, $t0
  li $v0, 1       # print int
  syscall
  li $a0, 10      # newline
  li $v0, 11      # print char
  syscall
  li $v0, 10      # exit
  syscall

                 # Euclid's algorithm
                 # a0 and a1 are the two integer parameters
                 # return value is in v0
gcd:
  move $t0, $a0
  move $t1, $a1
top:                  # done when t1 == 0
  beq $t1, $0, done   #
  div $t0, $t1        # t0 / t1    we are doing a mod operation.
  move $t0, $t1       # save quotient in t0
  mfhi $t1            # save the remainder in t1
  j top               # check the remainder above
done:                 #
  move $v0, $t0       # save return value
  jr $ra              #
