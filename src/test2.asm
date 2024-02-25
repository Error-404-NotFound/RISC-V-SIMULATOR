.data
arr: .word 3,4,1,2,-5,23,34,-1,213,-123,234,-435,456,-234234,12
size: .word 15
delimiter: .string ", "
str1: .string "Unsorted Array is: "
str: .string "Sorted Array is: "

.text 
main:
    la a0 arr
    la a1 size
    lw a1 0(a1)

    li a0 10
    li a7 11
    ecall
    la t4 size
    lw t4 0(t4)
    addi x25 x29 -1
    la x8 arr
    addi x15 x0 0
    


loop1:

    beq x15 x25 exit
    add x16 x0 x15
    addi x6 x15 1
    loop2:

        beq x6 x29 swap
        slli x7 x6 2
        slli x28 x16 2
        add x5 x8 x28
        lw x31 0(x5)
        add x5 x8 x7
        lw x30 0(x5)
        bge x30 x31 nochange
        add x16 x0 x6

    nochange:

        addi x6 x6 1
        addi x9 x0 5
        blt x6 x9 loop2

    swap: 
    
        slli x29 x15 2
        add x5 x29 x8
        lw x30 0(x5)
        slli x28 x16 2
        add x5 x28 x8
        lw x31 0(x5)
        add x5 x29 x8
        sw x31 0(x5)
        add x5 x28 x8
        sw x30 0(x5)
        addi x1 x0 4
        addi x15 x15 1
        blt x15 x1 loop1



exit:

    la x1 arr
    la x3 size
    lw x3 0(x3)
    li x4 0

    la x10 str
    li x17 4
    ecall

    loop:
        lw x2 0(x1)
        beq x3 x4 end
        j print
        
    print:
        addi x10 x2 0
        li x17 1
        ecall
        li a7 4
        la a0 delimiter
        ecall
        addi x1 x1 4
        addi x4 x4 1
        j loop

    end:
        li x17 10
        ecall