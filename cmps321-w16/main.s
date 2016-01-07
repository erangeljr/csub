# A simple "Hello world" program

  .text
  .globl  main
  .ent  main
main:
  la  $a0,format1  # Load address of format string into $a0
  jal printf       # Call printf

  la  $a0,format2  # load address of format string #2 into $a0
  li  $a1,50       # test %d format - load 50 into $a1
  jal printf       # call printf

  li  $v0,10       # 10 is the code for exiting
  syscall          # Execute the exit system call

  .end  main

  .data
format1: .asciiz "Hello world.\n"
format2: .asciiz "Register $a1 holds: %d\n"
format3: .asciiz "%d plus %d is %d\n"

