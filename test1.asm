.data
    array: .word 10,20,30
    str: .string "Hello, World"
.text
    li x1 1
    li x2 1
    li x3 4
    beq x1 x2 exit
    bne x1 x3 exit2
    li x3 10
exit:
    li x3 20
exit2:
    add x1 x2 x3
    sub x4 x5 x6