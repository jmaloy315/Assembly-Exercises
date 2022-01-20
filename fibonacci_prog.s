   .data

# array terminated by 0 (which is not part of the array)
xarr:
   .word 1
   .word 2
   .word 3
   .word 4
   .word 10
   .word 11
   .word 12
   .word 13
   .word 14
   .word 16
   .word 18
   .word 20
   .word 24
   .word 0

   .text

# main(): ##################################################
#   uint* j = xarr
#   while (*j != 0):
#     printf(" %d\n", fibonacci(*j))
#     j++
#
main:
   li   $sp, 0x7ffffffc    # initialize $sp

   # PROLOGUE
   subu $sp, $sp, 8        # expand stack by 8 bytes
   sw   $ra, 8($sp)        # push $ra (ret addr, 4 bytes)
   sw   $fp, 4($sp)        # push $fp (4 bytes)
   addu $fp, $sp, 8        # set $fp to saved $ra

   subu $sp, $sp, 8        # save s0, s1 on stack before using them
   sw   $s0, 8($sp)        # push $s0
   sw   $s1, 4($sp)        # push $s1

   la   $s0, xarr          # use s0 for j. init to xarr
main_while:
   lw   $s1, ($s0)         # use s1 for *j
   beqz $s1, main_end      # if *j == 0 go to main_end
   move $a0, $s1
   jal  fibonacci          # result = fibonacci(*j)
   move $a0, $v0           # print_int(result)
   li   $v0, 1
   syscall
   li   $a0, 10            # print_char('\n')
   li   $v0, 11
   syscall
   addu $s0, $s0, 4        # j++
   b    main_while
main_end:
   lw   $s0, -8($fp)       # restore s0
   lw   $s1, -12($fp)      # restore s1

   # EPILOGUE
   move $sp, $fp           # restore $sp
   lw   $ra, ($fp)         # restore saved $ra
   lw   $fp, -4($sp)       # restore saved $fp
   j    $ra                # return to kernel
## end main #################################################
 fibonacci:	
   # PROLOGUE
   subu    $sp, $sp, 8
   sw    $ra, 8($sp)
   sw    $fp, 4($sp)
   addu    $fp, $sp, 8

   # BODY
   beqz $a0, retzero
   beq $a0, 1, retone

   sub $sp, $sp, 4 # storing $a0's value so it can be restored
   sw $a0, 4($sp)

   sub $a0, $a0, 1 # make n-1
   jal fibonacci
   lw $a0, 4($sp) # restore $a0

   sub $sp, $sp, 4 # storing $v0's value so it can be added later
   sw $v0, 4($sp)

   sub $a0, $a0, 2 # make n-2
   jal fibonacci
   lw $t0, 4($sp) # $t0 contains the value of $v0 for n-1

   add $v0, $t0, $v0 # do the recursive call
   add $sp, $sp, 8

   j ret

retzero:
   li $v0, 0
   j ret

retone:
   li $v0, 1
   j ret
	
ret:	
   # EPILOGUE
   move    $sp, $fp
   lw    $ra, ($fp)
   lw    $fp, -4($sp)
   jr     $ra 
