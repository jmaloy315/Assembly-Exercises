   .data
# uint arrays, each terminated by -1 (which is not part of array)
data0:
   .word 1, 2, 3, 4, -1
data1:
   .word 2, 3, 4, 5, -1
data2:
   .word 5, 4, 3, 2,  -1
data3:
   .word 200456, 3345056, 1, 2, 1, 2, -1
overflow:
   .word 1, 1, 1, 1, 2147483646, -1

   .text

# main(): ##################################################
#   process_array(data0)
#   process_array(data1)
#   process_array(data2)
#   process_array(data3)
#   process_array(overflow)
#
main:
   # PROLOGUE
   subu $sp, $sp, 8        # expand stack by 8 bytes
   sw   $ra, 8($sp)        # push $ra (ret addr, 4 bytes)
   sw   $fp, 4($sp)        # push $fp (4 bytes)
   addu $fp, $sp, 8        # set $fp to saved $ra

   la   $a0, data0
   jal  process_array
   la   $a0, data1
   jal  process_array
   la   $a0, data2
   jal  process_array
   la   $a0, data3
   jal  process_array
   la   $a0, overflow
   jal  process_array

   # EPILOGUE
   move $sp, $fp           # restore $sp
   lw   $ra, ($fp)         # restore saved $ra
   lw   $fp, -4($sp)       # restore saved $fp
   j    $ra                # return to kernel
## end main ################################################

# process_array(uint* arr): #################################
#   print_array(arr)
#   reverse_prefix_sum(arr)
#   print_array(arr)
#
process_array:
   # PROLOGUE
   subu $sp, $sp, 8        # expand stack by 8 bytes
   sw   $ra, 8($sp)        # push $ra (ret addr, 4 bytes)
   sw   $fp, 4($sp)        # push $fp (4 bytes)
   addu $fp, $sp, 8        # set $fp to saved $ra

   subu $sp, $sp, 4        # save s0 on stack before using it
   sw   $s0, 4($sp)

   move $s0, $a0           # use s0 to save a0
   jal  print_array
   move $a0, $s0
   jal  reverse_prefix_sum
   move $a0, $s0
   jal  print_array

   lw   $s0, -8($fp)       # restore s0 from stack

   # EPILOGUE
   move $sp, $fp           # restore $sp
   lw   $ra, ($fp)         # restore saved $ra
   lw   $fp, -4($sp)       # restore saved $fp
   j    $ra                # return to kernel
## end process_array #######################################

# print_array(uint arr): ########################################
#   uint x
#   while (-1 != (x = *arr++)):
#     printf("%d ", x)
#   printf("\n")
#
print_array:
   # use t0 to hold arr. use t1 to hold *arr
   move $t0, $a0
print_array_while:
   lw   $t1, ($t0)
   beq  $t1, -1, print_array_endwhile
   move $a0, $t1           # print_int(*arr)
   li   $v0, 1
   syscall
   li   $a0, 32            # print_char(' ')
   li   $v0, 11
   syscall
   addu $t0, $t0, 4
   b    print_array_while
print_array_endwhile:
   li   $a0, 10            # print_char('\n')
   li   $v0, 11
   syscall
   jr   $ra
## end print_array #########################################
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

