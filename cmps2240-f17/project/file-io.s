# file-io.s
# PUT YOUR NAME HERE
# test file i/o syscalls 
# assumes a file named data exists in the current directory
#    $ spim -f file-io.s
#   OR
#  (spim) re "file-io.s"
#  (spim) breakp b1
#  (spim) run 
#
# file_open   $v0 = 13   
#             $a0 = full path (null terminated string)
#             $a1 = flags, use 0 for reading 
#             $a2 = UNIX octal file mode (0644 for rw-r--r--)   
#             returns $v0 = file descriptor   
#
# file_read   $v0 = 14   
#             $a0 = file descriptor
#             $a1 = buffer address 
#             $a2 = amount to read in bytes 
#             returns $v0= amount of data in buffer from file (-1=error, 0=EOF) 
#
# file_write  $v0 = 15 
#             $a0 = file descriptor
#             $a1 = buffer address 
#             $a2 = amount to write in bytes
#             returns $v0 = amount of data in buffer to file (-1=error, 0=EOF)  
#
# file_close  $v0 = 16   
#             $a0 = file descriptor
#

  .text
       .globl main
       .globl b1     # do this to set a break point
 
main:
   # open file for reading
   li  $v0, 13        # 13 is file open syscall  
   la  $a0, filename  # filename
   add $a1, $0, $0    # flags=O_RDONLY=0   - (add $a1, $0,$0 is like a move $0)
   add $a2, $0, $0    # mode=0
   syscall

   add $s0, $v0, $0   # store fd in $s0 before you overwrite it

   # check value of file descriptor in $s0; -1 means a file open error occurred
   bltz  $s0, error

   # read 4 bytes from file, storing in buffer
   li   $v0, 14       # 14=read from  file
   move $a0, $s0      # $s0 holds fd - load this into $a0
   la   $a1, buffer   # load the address to the buffer 
   li   $a2, 4        # load the size of buffer
   syscall

   # check error condition
   bltz $v0, error    # amount of data read is in v0 

   b1:    # put in break point for debugging purposes

   # do this to display number of bytes read - when $v0 = 0 you have hit EOF
   # this code is useful for debugging - uncomment if you wish
 
   # move $a0, $v0     
   # li   $v0, 1      
   # syscall

   # print the buffer - print string syscall will stop at \0 
   li   $v0, 4        # 4=print string 
   la   $a0, buffer   # buffer is 4 bytes followed by a null byte 
   syscall     


   # read 4 more bytes
   li   $v0, 14        # 14=read from file 
   add  $a0, $s0, $0  # $s0 holds fd
   syscall

   # print the buffer 
   li   $v0, 4        # 4=print string 
   la   $a0, buffer   # buffer is 4 bytes followed by a null byte 
   syscall     

   # print a final line feed   - useful for debugging so you know where you end
   li   $a0, 10       
   li   $v0, 11     
   syscall

   # close file
   li  $v0, 16        # 16=close file
   add  $a0, $s0, $0  # $s0 holds fd
   syscall            # close file
   b exit 

error:                # file i/o error 
   li $v0, 4
   la $a0, errormsg
   syscall
   
exit:  
   # exit 
   li  $v0, 10
   syscall
      .data

filename:
  .asciiz  "data"  # filename
  .word   0       # do this to align things
buffer:  
  .space  4       # a buffer of size 4 bytes 

  .space 1 '\0'   # stuff a null character at the end of the buffer

  .word   0       # do this to align things
errormsg:
  .asciiz  "file open or read error\n"

linefeed:
   .asciiz "\n"
