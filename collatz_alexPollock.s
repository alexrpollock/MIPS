# Alex Pollock
# CSCI341 Section B
# Tested with QTSpim
.data
    input:	.asciiz "Input for Collatz conjecture: "
    result:	.asciiz "Number of steps: "
    space:	.asciiz " "
    newline:	.asciiz "\n"
.text
.globl main
main:
    li $v0,4        # Print ascii function
    la $a0,input    # Load address of message
    syscall         # Print
    
    li $v0,5        # Read integer
    syscall         # Read it
    add $a0,$v0,$zero # Load first argument register with input
    li $v0, 0

    ##########################################
    jal collatz         # Call collatz(input)
    ##########################################
    
    move $t0, $v0   #Preserve result of collatz()
    
    li $v0, 4        # Print ascii function
    la $a0, newline    # Load address of message
    syscall         # Print
    
    li $v0,4        # Print ascii function
    la $a0, result    # Load address of message
    syscall         # Print

    move $a0, $t0   # Load output of "collatz(input)" to first arg of print
    li $v0,1        # Print integer function
    syscall         # Print

    li $v0,10       # Exit program function
    syscall         # Exit

######################################################
collatz:
    # allocate space on the stack, store saved registers
    addi $sp, $sp, -12
    sw $s0, 0($sp)
    sw $ra, 4($sp)

    move $s0, $a0

    sw $v0, 8($sp)

    # print integer and space
    li $v0, 1
    syscall

    li $v0, 4
    la $a0, space
    syscall

    lw $v0, 8($sp)

    # if number == 1, go to exit
    li $t0, 1
    beq $s0, $t0, exit

    # if number is even
    and $t1, $s0, $t0
    beq $t1, $zero, even

    # number is odd -> recursive call with 3*n+1
    sll $a0, $s0, 1
    add $a0, $a0, $s0
    addi $a0, $a0, 1
    jal collatz
    j exit

    # number is even -> recursive call with n/2
even:
    srl $a0, $s0, 1
    jal collatz

    # number is 1 -> return and deallocate space on the stack
exit:
    addi $v0, $v0, 1
    lw $s0, 0($sp)
    lw $ra, 4($sp)
    addi $sp, $sp, 12
    jr $ra

