.data
    arr: .word 3 3 4 3
    prom1: .string "IIT Tirupati \n"
    prom2: .string "Value of i is: "


.text
        
main:
    addi x3 x0 3     #x3 is k
    addi x4 x0 0     #x4 is i
    la x18 arr     
    lw x11 0(x18)     #arr first element

loop:
    lw x12 0(x18)
    bne x12 x3 exit
    addi x4 x0 2
    addi x18 x0 8
    j loop

exit:
    li a7 4
    la a0 prom1
    ecall
    la a0 prom2
    ecall
    li a7 1
    add a0 x0 x4
    ecall