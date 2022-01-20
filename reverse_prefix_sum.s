reverse_prefix_sum:
   # PROLOGUE
   subu $sp, $sp, 8        # expand stack by 8 bytes
   sw   $ra, 8($sp)        # push $ra (ret addr, 4 bytes)
   sw   $fp, 4($sp)        # push $fp (4 bytes)
   addu $fp, $sp, 8        # set $fp to saved $ra

   # BODY

   subu $sp, $sp, 4 # saving r on the stack
   sw $t6, 4($sp)

   lw $t5, 0($a0) # t5 represents *arr

   subu $sp, $sp, 4 # saving *arr on the stack
   sw $t5, 4($sp)

   beq $t5, -1, retzero

   add $a0, $a0, 4
   jal reverse_prefix_sum # recursive call on arr + 1
   lw $t5, 4($sp) # restore *arr

   move $t1, $v0 # value of recursive call
   addu $t6, $t1, $t5 # r
   sub $a0, $a0, 4
   sw $t6, 0($a0)
   move $v0, $t6

   j ret

retzero:
   li $v0, 0
   j ret

ret:		
   # EPILOGUE
   move $sp, $fp           # restore $sp
   lw   $ra, ($fp)         # restore saved $ra
   lw   $fp, -4($sp)       # restore saved $fp
   j    $ra                # return to kernel

