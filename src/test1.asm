.data
    arr: .word 3,4,1,2,-5,23,34,-1,213,-123,234,-435,456,-234234,12
    size: .word 15
    delimiter: .string ", "
    promp1: .string "Unsorted array is: "
    promp2: .string "Sorted array is: "

.text
    li a7 4
    la a0 promp1
    ecall
    la a0 arr
    la a1 size
    lw a1 0(a1)

    jal x31 print
    li a0 10
    li a7 11
    ecall

    la a0 arr
    la a1 size
    lw a1 0(a1)

    jal ra bubbleSort 

    la a0 promp2
    li a7 4
    ecall
    
    la a0 arr
    la a1 size
    lw a1 0(a1)

    jal x31 print
    li a7 10
    ecall

print:
    mv t0 a0
    mv t1 a1
    loop:
        li a7 1
        lw a0 0(t0)   
        ecall
        li a7 4
        la a0 delimiter
        ecall
        addi t0 t0 4
        addi t1 t1 -1
        bne t1 zero loop
        jr x31

bubbleSort:
    mv t0 a0
    mv t1 a1
    addi t1 t1 -1
    li t2 1

    oloop:
        li t2 0
        li t3 0
        mv t0 a0
        iloop:
            beq t3 t1 eloop
            lw t4 0(t0)
            lw t5 4(t0)
            ble t4 t5 noswap
            sw t5 0(t0)
            sw t4 4(t0)
            li t2 1
            noswap:
                addi t0 t0 4
                addi t3 t3 1
                j iloop
        eloop:
        addi t1 t1 -1
        bne zero t2 oloop
        jr ra
