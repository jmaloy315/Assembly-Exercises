is_palindrome:	

   # PROLOGUE
   subu    $sp, $sp, 8
   sw    $ra, 8($sp)
   sw    $fp, 4($sp)
   addu    $fp, $sp, 8

   # BODY
   li $t0, 0 # used for i in for loop
   li $t3, 0

   move $t1, $a0 # t1, t2 used for comparing string backwards and forewards
   move $t2, $a0

   lbu $t4, 0($a0) # used for foreward indexing
   lbu $t5, 0($a0) # used for backwards indexing

   j strlen

strlenend:
   sub $t3, $t3, 1 # removing the extra count for the null byte
   add $t2, $t1, $t3 # t2 is the end of the string now
   lbu $t5, 0($t2) # t5 is now the end of the string
   div $t3, $t3, 2 # max index for the for loop

loop:
   beq $t0, $t3, endfail # if for loop iterates all the way through, fails
   bne $t4, $t5, endsucc # if string is a palindrome, succeeds
   add $t0, $t0, 1 # incrementing i

   add $t1, $t1, 1 # going foreward from the start
   sub $t2, $t2, 1 # going back from the end

   lbu $t4, 0($t1) 
   lbu $t5, 0($t2)
   j loop

endfail:
   li $v0, 1
   j ret
endsucc:
   li $v0, 0
   j ret
	
ret:	
   # EPILOGUE
   move    $sp, $fp
   lw    $ra, ($fp)
   lw    $fp, -4($sp)
   jr     $ra 

strlen:
  beqz $t5, strlenend

  add $t3, $t3, 1
  add $t2, $t2, 1

  lbu $t5, 0($t2)
  j strlen
