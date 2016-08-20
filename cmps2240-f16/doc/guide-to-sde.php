<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
  <head> <title>CMPS 224</title>
    <?php include 'head.php' ?>
  </head> <body> <div id='wrapper' class='content'>
      <div id='header' class='round'>
          <h1>CMPS 224 GUIDE TO USING MIPS SDE</h1>
    <?php include 'menu.php' ?> </div>
      <div id='main'> <div id='center'>
<p>
 These instructions show  you how to write, assemble and execute
 a MIPS assembly program using MIPS Technologies (mips.com)
 SDE (software development environment). MIPS SDE is a 
 complete production development environment that assembles MIPS
 for a wide-range of target platforms, including non-MIPS machines.
 The target platform
 for this lab is sleipnir, a machine with Intel (80x86 architecture)
 processors running GNU Linux. Using SDE gives the programmer
 the power of assembly but with a language that is relatively
 clean and simple compared to x86 assembly. 
 </p>
 <p> 
 Your first task is to
 set up an area in
 your account on sleipnir to run SDE. Follow the instructions in
 the <a href="./doc/sde-setup.txt">SDE Setup Guide</a>. If all goes 
 well, you should have assembled and executed the hello.s source 
 program shown here.
  </p> 
 <div class="code"> <pre class="code">
# "Hello world" program in MIPs assembly
#   $ sde-make
#   $ sde-run helloram
                                  #.{assembler directive}
.text                             # beginning of text section
.globl main                       # main must be global 
.ent   main                       # entry directive for procedure main
 
main:                             # {name}: is a label
   la   $a0, format               # load address of format string into reg $a0
   jal  printf                    # jump and link to printf procedure
   li   $v0,10                    # load immediate 10 which is exit system call
   syscall                        # execute the system call
.end  main                        # end directive for procedure main 
.data                             # beginning of data section
format:
    .asciiz "Hello world.\n"      # z (zee) makes the string null terminated
</pre> </div>
<p>
  The source code above
 has two sections, a data section and a text section.
  The data section holds literals such as the "Hello world" string.
  The text section contains instructions and assembler directives. 
  Instructions are in the form of an opcode (operation code) followed by
  zero, one, two or three
  arguments for that opcode. 

 An argument for a MIPS instruction is either a register, a literal, or 
 an address (denoted by a label).  
 The amount of whitespace between opcodes
 and arguments is irrelevant.
 </P>
  Before understanding the arguments
  you must understand the concept of a register.
  If you haven't taken CMPS 321, start by 
 reading
  <a href="http://cnx.org/content/m29470/1.1/">Processor Organization</a>.
 In MIPS, a register can hold either a value or an address depending on the
 instruction. 
 <p>
 MIPS instructions that are not part of the MIPS instruction set 
 architecture (the hardware) but are provided to make the programmer's 
  life a little easier are called pseudo-instructions. 
 Load address, <code>la</code>, is one such pseudo-instruction. <pre>
      la $a0, format   # load address of the label into register a0</pre>
 
 The two arguments for <code>la</code> 
 specify the movement of data from
 memory (the source) to a register (the target).
 Be careful not to confuse the two (since the source is to the right
 of the target it may not be intuitive). There is a reason for this.
 Unlike 80x86, MIPS is a LOAD/STORE architecture. This means that 
  there is no memory to memory data transfer. Data must
  be read from memory into
 a register (LOAD) or written to memory from a register (STORE). 
 The first argument in a load instruction is the target register.
 The first argument in a store is the source register. Load instructions are 
  logically read from right to left (load the address of "Hello world\n"
 into register a0) whereas store instructions are read from left to right:<pre>
      sw $a0, $t0      # store value in a0 to address in register t0  </pre>

<p/>

<p> 
   The load immediate, <code>li</code>, is  also
 a pseudo-instruction that loads the numeric 
  constant 10 (source) into the target register $v0.
 The <code>syscall</code>
  instruction executes a system call identified
 by the integer value in register $v0. In this case '10' is the exit call. 
</p>
 <p>
  Understanding the above concepts will be enough to complete this lab. 
  If you desire more details, browse through
  A-43 through A-81 in <a href="./doc/HP_AppenA.pdf">Hennessy & 
  Patterson Appendix A</a> 
  for a table of  syscall codes, assembler directives
  and a reference of MIPS R2000 Assembly Language instructions.
</p>
 STEP 1. Create a subdirectory named <code>test</code>
  under your sde directory. 
 Change into <code>test</code>
  and copy the Makefile from hello into
 test. These commands will do that: <pre>
      $ mkdir test
      $ cd test
      $ cp ../hello/Makefile . </pre>

Modify the Makefile so that all instances of <code>hello</code> 
 are changed to <code>sum</code>. 
</p>
<p>
STEP 2. Create an 
 assembly file called <code>sum.s</code> that takes two constants and adds them 
 together. The guts of the code  (the header and the syscall to exit)
 will be the same as hello.s.
 You must add the assembly instructions to hard-code the
 values of two integers and sum 
 two integers together.  You will use the li,
 addu and move instructions to do this. 
 Note that source register(s) are the right operands
 and the destination register is the left operand in these instructions:<pre>
      li     dest, integer      # load integer into destination register

      addu   dest,src1,src2     # add values in src1 and src2 registers and 
                                # store result in dest register

      move   dest, src          # move value in src register to dest register
</pre>
 You can also use fewer instructions if you want to use
 the add immediate instruction: <pre>
       addi   dest,src,integer   # add value in src and integer, store in dest 
</pre>
Which registers to use?
 The convention is to load 
 temporary values (such as the integers you are adding 
 together) into temporary registers $t0 - $t7. Save results of computations in
 the value registers $v0 - $v1.
</p>
<p>
 STEP 3.
 All that is left for you to do is  display the result.
Use printf to display the results by putting this in your
 <code>.data</code> section:<pre>
.data
format:
        .asciiz "The sum is %d\n"
</pre> and this to the correct spot in main: <pre>
        la      $a0,format      # load address of new format string in $a0
        move    $a1,$v0         # move the sum from $v0 to $a1 
        jal     printf          # call the printf function </pre>
 The move instruction assumes that the result of the add computation is
 in register $v0. Although you have control over which registers you use,
 you must stick with conventions if you call a function such as printf
 that expects things to be in a certain place. 

 
 </p>
<p>


        
        <div id='left' class='panel'>
          <?php include 'left.php' ?>
        </div>
        
        
      </div>
      <div id='footer' class='round'>
        <?php include 'footer.php' ?>
      </div>
    </div>
  </body>
</html>
