.data
    arr: .word 3,4
    size: .word 2

.text
    la a0 arr
    la a1 size
    lw a1 0(a1)

    jal ra bubbleSort 
    
    la a0 arr
    la a1 size
    lw a1 0(a1)
    j exit

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

exit:
    li x2 200