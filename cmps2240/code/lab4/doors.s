# file: doors.s
# MIPS implementation of the locker doors problem
#
# Problem Specification.
# There are 100 lockers, 1..100. The doors of all lockers are closed initially.
# A security guard makes 100 passes by the lockers, pass 1 to pass 100. If 
# the locker door is evenly divisable by the pass number, the guard toggles 
# the door (if open close it; if closed open it), otherwise the guard does
# nothing; i.e.,  on pass 1, all doors are opened since 1 divides all door nos;
# on pass 2, door 2,4,6...100 are closed; on pass 3 every third door is toggled
# (some will be open and some will be closed); and so on. 
#
#

.data
doors:     .space 100     # 100 bytes of contiguous memory - MIPS is byte
                          # addressable so this is an array of bytes
                          # 1 = open and 0 = closed
num_str:   .asciiz "door "
comma_gap: .asciiz " is "
newline:   .asciiz "\n"
 
.text
.globl close_doors   # globl lets you set a breakpoint at close_doors

.globl main
.ent main

main:
                     # setup some registers and call close_doors routine 
  li   $t1, 100      # t1 holds size of doors array
  la   $t2, doors    # point t2 to base address of doors array   
  jal  close_doors   # jump to close_doors

                     # Register Usage for outer and inner loops:
                     # $t0 - outer loop counter
                     # $t1 - inner loop counter
                     # $t2 - starting address to 100 bytes of contiguous memory 
                     # $t3 - use to toggle the door (reverse the bit) 

                     # setup some registers for the outer and inner loops
  li   $t4, 1        # t4=1; t4 is constant 1 
  li   $t0, 1        # t0=1; initialize outer loop counter to 1 

outer:
  move $t1, $t0        # t1=1; initialize inner loop counter to 1 
  la   $t2, doors      # point t2 to the base address of doors array
  add  $t2, $t2, $t0   # t2++
  addi $t2, $t2, -1    # t2-- 

inner:
  lb   $t3, ($t2)       # load byte at t2 to low-order byte of t3; sign-extend 
  sub  $t3, $t4, $t3    # t3=1-t3; if t3 is 1 it is 0; if 0 it is 1
  sb   $t3, ($t2)       # store low-order byte from t3 to t2; sign-extend
  add  $t1, $t1, $t0    # t1=t1+t0; increment inner loop counter by outer one;
                        # this steps through the array by stepsize = pass num 
  add  $t2, $t2, $t0    # t2++; increment address into array by one byte
                        # continue inner loop if loop counter <= 100
  ble  $t1, 100, inner

                        # we are now at the bottom of the outer_loop
  addi $t0, $t0, 1      # t0++ ; increment outer loop counter 
  ble  $t0, 100, outer  # continue outer loop if counter <= 100 

                        # we completed 100 passes so now display the status
                        # of all the doors 
  la   $t0, doors
  li   $t1, 1

show:
  li   $v0, 4
  la   $a0, num_str
  syscall
  li   $v0, 1
  move $a0, $t1
  syscall
  li   $v0, 4
  la   $a0, comma_gap
  syscall
  li   $v0, 1
  lb   $a0, ($t0)
  syscall
  li   $v0, 4,
  la   $a0, newline
  syscall
  addi $t0, $t0, 1
  addi $t1, $t1, 1
  bne  $t1, 101 show
  li   $v0, 10          # exit syscall
  syscall
.end main

                         # set each bytes in the array to 0
.ent close_doors      
close_doors:
   sb   $0, ($t2)        # store '0000' in low-order byte at t2; sign-extend
   add  $t2, $t2, 1      # t2++
   sub  $t1, $t1, 1      # t1--
   bnez $t1, close_doors # continue close_doors until t1 == 0
   jr   $ra
.end close_doors

