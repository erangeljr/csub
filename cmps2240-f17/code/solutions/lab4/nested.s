# One solution for lab-4 part 2.
# filename: nested.s
#
# This program will display the pattern below.
# Must use nested loops.
#
# This is the pattern of a diver-down flag.
#
#    . O O O O O O O O
#    O . O O O O O O O
#    O O . O O O O O O
#    O O O . O O O O O
#    O O O O . O O O O
#    O O O O O . O O O
#    O O O O O O . O O
#    O O O O O O O . O
#    O O O O O O O O .
#
#----------------------------------------------------
# Here is a C program that accomplishes the output.
#
# #include <stdio.h>
# int main()
# {
#     int i,j;
#     for (i=0; i<9; i++) {
#         for (j=0; j<9; j++) {
#             if (i==j)
#                 printf(" .");
#             else
#                 printf(" O");
#         }
#         printf("\n");
#     }
#     printf("\n");
#     return 0;
# }
#----------------------------------------------------

   .data                   # setup your characters
   oh:      .asciiz " O"   #
   dot:     .asciiz " ."   #
   space:   .asciiz " "    #
   newline: .asciiz "\n"   #
   .text                   # start the program
   .globl main
main:
   li $v0, 4               # get ready to print just characters
   li $t5, 9               # dimensions are 9 by 9
loop1top:
   li $t1, 0               # $t1 = iterator i
loop1test:                 # for (i=0; i<9; i++)
   bge $t1, $t5, loop1end  # if (i >= 9) then exit loop
   li $t2, 0               # $t2 = iterator j
loop2test:                 # for (j=0; j<9; j++)
   bge $t2, $t5, loop2end  # if (j >= 9) then exit loop
   la $a0, oh              # print oh or dot
   bne $t1, $t2, draw      # diagonal is when i == j
   la $a0, dot             # draw the dot
draw:
   syscall                 # show the character
   add $t2, 1              # increment i
   j loop2test             # continue the looping
loop2end:
   la $a0, newline         # go to a new row
   syscall                 #
   add $t1, 1              # increment j
   j loop1test
loop1end:
   la $a0, newline         # finishing up the printout
   syscall                 #
   li $v0, 10              # done
   syscall                 #

