.data
    input: .word 1234
    
.text
 li x10 1234
    
    li x5 0            #count number of 1s
    li x4 0            #count number of 0s
    li x6 32           #number of bits to check
    jal x2 loop

loop:
    beq x6 x0 exit     #exit loop when 32--==0
    andi x7 x10 1     #do and operation to check if current bit is 1
    beq x7 x0 skip     #skip if bit is 0
    addi x5 x5 1     #else increment counter

skip:
    srli x10 x10 1       #shift right by 1
    addi x6 x6 -1      #decrement iterator
    j loop             #jump to loop back

exit:
    li x10 32
    sub x4 x10 x5
    
    li x17, 10
    ecall