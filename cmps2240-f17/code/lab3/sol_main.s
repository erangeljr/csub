# filename: main.s
# purpose:  test output facilities in print.s and input facilities in read.s

#  spim> re "main.s"
#  spim> re "printf.s"
#  spim> re "read.s"
#  spim> run
#  spim> exit 

.text
.globl  main
.ent  main

main:
  la  $a0,go_label       # Load address of format string #1 into $a0
  jal printf       # call printf

  la $a0, road_label
  jal printf

  la $a0, year_label
  jal printf

                   # test %c
  la  $a0,format5  # load address of format string #5 into $a0
  lb  $a1,a_char   # load arbitrary byte to $a1 
  jal printf       # call printf


  jal read         # run the read procedure

  li  $v0,10       # 10 is exit system call
  syscall    

.end  main



.data
format1: 
  .asciiz "Hello world.\n"        # asciiz adds trailing null byte to string
format2: 
  .asciiz "Register $a1 holds: %d\n"  
format3: 
  .asciiz "%d plus %d is %d\n"
a_string:
  .asciiz "I am a string"
format4: 
  .asciiz "The string is: %s\n"
a_char:
  .byte 'a' 
format5: 
  .asciiz "The char is: %c\n"
go_label:
    .asciiz "Go \n"
road_label:
    .asciiz "Roadrunners \n"
year_label:
    .asciiz "in 2016! \n"
