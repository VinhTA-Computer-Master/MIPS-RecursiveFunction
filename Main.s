###################################
# Author: Vinh TA
# Description: Compute a function: y = (n-1) * function1(n-1) + function1(n-2) - n
###################################

	.data
ans:	.word 0
ans1:	.word 0
msg1:	.asciiz "Enter an integer:\n"
msg2: 	.asciiz "The solution is: "

	.text
	.globl main
main:
	la $a0, msg1
	li $v0, 4
	syscall

	li $v0, 5
	syscall
	move $a0, $v0		# $a0 = n
	
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	jal function1
	lw $ra, 0($sp)
	addi $sp, $sp, 4

	move $s0, $v0		# $s0 = ans
	
	la $a0, msg2
	li $v0, 4
	syscall
	
	move $a0, $s0
	li $v0, 1
	syscall

	jr $ra			# return

############################################################################
# Function: function1
# Description: piecewise recursive function
# parameters: $a0 = n
# return value: $v0 = ans1
# registers to be used: $t0 will be used.
############################################################################

function1:
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	addi $sp, $sp, -4
	sw $a0, 0($sp)
	
	li $t0, 3
	slt $t0, $t0, $a0		# 3 > n, $t0 = 0
	bne $t0, $zero, recursive	# 3 < n, branch
	li $t0, 3
	mul $t1, $a0, 3
	addi $t2, $t1, -5
	move $v0, $t2		# $v0 = ans1

	lw $a0, 0($sp)
	addi $sp, $sp, 4
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	
	jr $ra			# return ans1

  recursive:
	addi $sp, $sp, -4	# backup $a0
	sw $a0, 0($sp)

	addi $a0, $a0, -1	# n - 1

	  jal function1		# function1(n-1)

	lw $a0, 0($sp)		# restore $a0
	addi $sp, $sp, 4
	addi $a0, $a0, -1	# n-1
	mul $t0, $a0, $v0	# (n-1)*function1(n-1)

	addi $a0, $a0, -1	# n-2
	addi $sp, $sp, -4
	sw $t0, 0($sp)		# backup $t0
	
	  jal function1		# function1(n-2)

	lw $t0, 0($sp)		# restore $t0
	addi $sp, $sp, 4
	lw $a0, 0($sp)		# restore $a0
	addi $sp, $sp, 4
	add $t1, $t0, $v0	# (n-1)*function1(n-1) + function1(n-2)
	sub $t2, $t1, $a0	# (n-1)*function1(n-1) + function1(n-2) - n

	move $v0, $t2		# $v0 = ans1
	
	lw $ra, 0($sp)		# restore $ra
	addi $sp, $sp, 4
	jr $ra			# return ans1





