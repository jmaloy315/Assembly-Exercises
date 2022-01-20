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
