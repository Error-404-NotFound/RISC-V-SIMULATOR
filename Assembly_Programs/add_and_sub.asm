.data
    promp1: .string "Addition: "
    promp2: .string "\nSubtraction: "
    buffer:  .zero 255

.text

main:
    addi x1 zero 10         # x1 = 10
    addi x2 zero 20         # x2 = 20
    jal x3 addition         # jal x3 addition
    jal x4 sub              # jal x4 subtraction
    jal x31 print           # jal x31 print
    
    li a7 10                # exit
    ecall                   # ecall
    
addition:
    add x5 x1 x2            # x5 = x1 + x2
    jr x3                   # return
    
sub:
    sub x6 x1 x2            # x6 = x1 - x2
    jr x4                   # return

print:
    li a7 4                 # print
    la a0 promp1            # load address of promp1
    ecall                   # ecall
    li a7 1                 # print
    mv a0 t0                # move t0 to a0
    ecall                   # ecall
    li a7 4                 # print
    la a0 promp2            # load address of promp2
    ecall                   # ecall
    li a7 1                 # print
    mv a0 t1                # move t1 to a0
    ecall                   # ecall
    jr x31                  # return
