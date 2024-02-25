.data
    size: .word 1234
    promp1: .string "The number is: "
    promp2: .string "\nNumber of 1 is: "
    promp3: .string "\nNumber of 0 is: "
    buffer: .zero 32
    
.text

main:
    la a1 size
    lw a0 0(a1)
    jal x1 print
    
    li t0 0            #count number of 1s
    li tp 0            #count number of 0s
    li t1 32           #number of bits to check
    jal x2 loop

print:
    li a7 4
    la a0 promp1
    ecall
    la a1 size
    lw a0 0(a1)
    li a7 1
    ecall
    jr x1


loop:
    beq t1 zero exit     #exit loop when 32--==0
    andi t2 a0 1     #do and operation to check if current bit is 1
    beq t2 zero skip     #skip if bit is 0
    addi t0 t0 1     #else increment counter

skip:
    srli a0 a0 1       #shift right by 1
    addi t1 t1 -1      #decrement iterator
    j loop             #jump to loop back

exit:
    li a0 32
    sub tp a0 t0
    li a7 4
    la a0 promp2
    ecall
    
    li a7 1
    mv a0 t0
    ecall
    
    li a7 4
    la a0 promp3
    ecall
    
    li a7 1
    mv a0 tp
    ecall
    li a7, 10
    ecall
