.data
    arr: .word 1 2 3 4 5 6 7 8 9 10

.text
    la a0 arr
    li a1 10
    li a2 0
    li a3 0

loop:
    lw t0 0(a0)
    add a2 a2 t0
    addi a0 a0 4
    addi a3 a3 1
    bne a3 a1 loop
    li a7 100