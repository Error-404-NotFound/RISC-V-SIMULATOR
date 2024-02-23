.data
    array: .word 3,4,1,2,5
    size: .word 5

.text
    la x10 array
    lw x11 size
    jal x1 bubbleSort 
    la x10 array
    lw x11 size
    li x17 10
    ecall

bubbleSort:
    mv x5 x10
    mv x6 x11
    addi x6 x6 -1
    li x7 1

    oloop:
        li x7 0
        li x28 0
        mv x5 x10
        iloop:
            beq x28 x6 eloop
            lw x29 0(x5)
            lw x30 4(x5)
            ble x29 x30 noswap
            sw x30 0(x5)
            sw x29 4(x5)
            li x7 1
            noswap:
                addi x5 x5 4
                addi x28 x28 1
                j iloop
        eloop:
        addi x6 x6 -1
        bne x0 x7 oloop
        jr x1