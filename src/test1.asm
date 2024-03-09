
.data
arr: .word 1 2 3

.text
    li a0 142
    li a1 0
    add a1 a1 a0
    addi a1 a1 4
    li a2 -46
    mv a7 a1
    add a7 a7 a2
    
