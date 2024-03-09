.data
    arr: .word 1 2 3 4 5 6 7 8 9 10

.text
    li a1 4
    sw a1 0(a0)
    lw a3 0(a0)
    add a3 a3 a3
