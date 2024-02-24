.data
array: .word -3,0 ,4,5 7
str: .string "The value is: "
.text
    la x1 array
    li x3 5
    li x4 0


    la x10 str
    li x17 4
    ecall

    loop:
        lw x2 0(x1)
        beq x3 x4 end
        j print
        
    print:
        addi x10 x2 0
        li x17 1
        ecall
        addi x10 x0 32
        li x17 11
        ecall
        addi x1 x1 4
        addi x4 x4 1
        j loop

    end:
        li x17 10
        ecall

