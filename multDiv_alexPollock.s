# Program By: Alexandra Pollock (10795912)
# Section: B
# Completed using QTSpim

# Super cool program that MULTIPLIES AND DIVIDES UNSIGNED INTEGERS!!!

.data	
    num1:       .word   0
    num2:       .word   0
    oper:       .space 3
    newline:    .asciiz "\n"
    p1:         .asciiz "Please enter the first operand: "
    p2:         .asciiz "Please enter the second operand: "
    po:         .asciiz "Please enter the operation (*, /): "
    zError:         .asciiz "Error: cannot divide by zero."
    remPrint:        .asciiz " Remainder: "
    mulChar:        .asciiz "*"
    divChar:        .asciiz "/"
    eqChar:        .asciiz "="


.text

.globl multFunc

multFunc:

    # multipicand is $a0, multiplier is $a1

    # multipicand register: $t1
    # upper (left) half of prod register: $t2
    # lower (right) half of product register: $t3
    # counter: $t4

    # put the first operand into the multipicand register
    move $t1, $a0
    # zero the upper half of the product register
    add $t2, $zero, $zero
    # put the seccond operand into the lower half of the product register
    move $t3, $a1
    # initialize the counter to zero
    add $t4, $zero, $zero
    # doMult label
    doMult:
    # load immediate 1 into register $t0
    li $t0, 0x00000001
    # and $t0 with lower half of the product register
    and $t5, $t0, $t3
    # branch if equal (skipMult) if above reg is 0
    beq $t5, $zero, skipMult
    # add multiplicand to the left half of product and place result in left half of product register
    add $t2, $t1, $t2
    # skipMult label
    skipMult:
    # shift the product register:
    # and $t0 with the upper half of prod register, store in $t0
    and $t0, $t0, $t2
    # shift right logical 1 bit upper half of prod register. store in upper half prod register
    srl $t2, $t2, 1
    # shift right logical 1 bit lower half of prod register. store in lower half prod register
    srl $t3, $t3, 1
    # shift left logical $t0 31 bits
    sll $t0, $t0, 31
    # add the lower half of prod register with $t0, store in lower half of product register
    add $t3, $t3, $t0
    # increment counter
    addi $t4, $t4, 1
    # load immediate 32 into reg
    li $t5, 32
    # compare immediate with counter
    slt $t5, $t4, $t5 # $t5 = 1 if counter < 32
    # bne 32 and counter, doMult
    bne $t5, $zero, doMult

    # all done, print result
    move $a0, $t1
    li $v0, 1
    syscall

    la $a0, mulChar
    li $v0, 4
    syscall

    move $a0, $a1
    li $v0, 1
    syscall

    la $a0, eqChar
    li $v0, 4
    syscall

    move $a0, $t3
    li $v0, 1
    syscall

    jr $ra

.globl divFunc

divFunc:

    # dividend is $a0, divisor is $a1

    # divisor register: $t1
    # upper (left) half of remainder register: $t2
    # lower (right) half of remainder register: $t3
    # counter: $t4

    # store dividend for printing later
    move $t6, $a0
    # put the dividend in the lower half of remainder register
    beq $a1, $zero, zeroErr
    move $t3, $a0
    # move the divisor into the divisor register
    move $t1, $a1
    # initialize the upper half of the remainder register to 0
    add $t2, $zero, $zero
    # initialize the counter to zero
    add $t4, $zero, $zero
    # $t0 = 0x80000000
    li $t0, 0x80000000
    # and $t0 with lower half of remainder reg, store in $t0
    and $t0, $t0, $t3
    # shift left logical 1 bit the upper half of the remainder register, store in same
    sll $t2, $t2, 1
    # shift left logical 1 bit the lower half of the remainder register, store in same
    sll $t3, $t3, 1
    # shift right logical $t0, 31 bits, store in same
    srl $t0, $t0, 31
    # add the upper half of the remainder register with $t0, store in upper half of remainder reg
    add $t2, $t2, $t0
    # doDiv label
    doDiv:
    # subtract the divisor from the upper half of the remainder register, store result in upper half
    sub $t2, $t2, $t1
    # test if the upper half of the remainder reg is < 0
    # slt $t0 if upper half is less than 0
    slt $t0, $t2, $zero
    # beq $t0, $0 step 3a
    beq $t0, $zero, step3A
    # label step 3b
    step3B:
    # add back divisor to upper half of the remainder register
    add $t2, $t1, $t2
    # load $t0 with 0x80000000
    li $t0, 0x80000000
    # and $t0 with lower half of remainder register, store in $t0
    and $t0, $t0, $t3
    # shift left logical 1 bit upper half of remainder reg.
    sll $t2, $t2, 1
    # shift left logical 1 bit lower half of remainder reg.
    sll $t3, $t3, 1
    # shift right logial $t0, 31 bits
    srl $t0, $t0, 31
    # add the upper half of the remainder register with $t0, store in upper half
    add $t2, $t2, $t0
    # jump to label, continue
    j continue
    # label step 3a
    step3A:
    # load $t0 with 0x80000000
    li $t0, 0x80000000
    # and $t0 with lower half of remainder register, store in $t0
    and $t0, $t0, $t3
    # shift left logical 1 bit upper half of remainder reg.
    sll $t2, $t2, 1
    # shift left logical 1 bit lower half of remainder reg.
    sll $t3, $t3, 1
    # shift right logial $t0, 31 bits
    srl $t0, $t0, 31
    # add the upper half of the remainder register with $t0, store in upper half
    add $t2, $t2, $t0
    # load $t0 with 0x00000001
    li $t0, 0x00000001
    # or lower half of remainder register with $t0, store in lower half
    or $t3, $t3, $t0
    # label continue
    continue:
    # increment counter
    addi $t4, $t4, 1
    # load immediate 32 into $t0
    li $t0, 32
    # bne $t0, counter doDiv
    bne $t0, $t4, doDiv
    # srl upper half of remainder register, 1 bit
    srl $t2, $t2, 1


    # print the results

    move $a0, $t6
    li $v0, 1
    syscall

    la $a0, divChar
    li $v0, 4
    syscall

    move $a0, $a1
    li $v0, 1
    syscall

    la $a0, eqChar
    li $v0, 4
    syscall

    move $a0, $t3
    li $v0, 1
    syscall

    la $a0, remPrint
    li $v0, 4
    syscall

    move $a0, $t2
    li $v0, 1
    syscall

    jr $ra

zeroErr:
    la $a0, zError
    li $v0, 4
    syscall

    jr $ra


.globl main

main:
    la $a0, p1
    li $v0, 4
    syscall

    li $v0, 5
    syscall
    add $s0, $v0, $zero     # $s0 has first operand

    la $a0, p2
    li $v0, 4
    syscall

    li $v0, 5
    syscall
    add $s1, $v0, $zero     # $s1 has second operand

    la $a0, po
    li $v0, 4
    syscall

    la $a0, oper            # puts entered stuff into "operator" string
    li, $a1, 3              # reads 3 things: a character, an enter, and a null
    li $v0, 8               # load the "read string" syscall number
    syscall

    la $s2, oper            # operator = s2 = value returned
    lbu $s3, 0($s2)         # loads the character entered by the user
    la $t0, mulChar         # loads the address of the multiply symbol
    lbu $s4, 0($t0)         # loads the multiply symbol

    add $a0, $s0, $zero
    add $a1, $s1, $zero

    beq $s3, $s4, multFunc  #if the character entered is *, perform multiply algorithm
    bne $s3, $s4, divFunc

	li	$v0, 10		        # Load the system call number to terminate program
	syscall
