isqrt:

   # PROLOGUE
   subu $sp, $sp, 8        # expand stack by 8 bytes
   sw   $ra, 8($sp)        # push $ra (ret addr, 4 bytes)
   sw   $fp, 4($sp)        # push $fp (4 bytes)
   addu $fp, $sp, 8        # set $fp to saved $ra

   # BODY
   blt $a0, 2, base # the base case

   sub $sp, $sp, 4 # saving the value of n on the stack
   sw $a0, 4($sp)

   srl $a0, $a0, 2 # shifting n 2 bits right
   jal isqrt # recursive call on n>>2
   sll $v0, $v0, 1 # shifting ret value 1 to the left

   sub $sp, $sp, 4 # saving the value of small on the stack
   sw $v0, 4($sp)

   add $v0, $v0, 1 # $v0 now holds the value of large

   mul $t0, $v0, $v0 # used for the last conditional

   lw $a0, 8($sp) # restore n for the last conditional
   bgt $t0, $a0, small
   j ret # return large

small:
   lw $v0, 4($sp) # restore return value to small
   j ret

base:
   move $v0, $a0
   j ret
	
ret:	
   # EPILOGUE
   move $sp, $fp           # restore $sp
   lw   $ra, ($fp)         # restore saved $ra
   lw   $fp, -4($sp)       # restore saved $fp
   j    $ra                # return to kernel
