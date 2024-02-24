.data
    array: .word 3 3 4 3
    str: .string "Final array: "


.text
    la x1 array
    li x3 0
    li x4 4
    la x10 str
    li x17 4
    ecall
loop:
    beq x3 x4 exit
    lw x2 0(x1)
    addi x10 x2 0
    li x17 1
    ecall
    li x17 32
    ecall
    addi x1 x1 4
    addi x3 x3 1
    j loop


exit:
    li x17 10
    ecall