.data
    arr: .word 3,4,1,5,6,7,8,9,2,10
    size: .word 10

.text
    la a0 arr
    lw a1 0(a0)
    lw a2 4(a0)
    sw a2 0(a0)
    sw a1 4(a0)