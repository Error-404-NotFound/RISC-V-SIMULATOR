.data
arr: .word 1 2 3

.text
    li a0 5
    li a1 5
    beq a0 a1 L1
    li a7 100

L1:
    li a6 200