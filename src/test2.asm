.data
    input: .word 1234

.text
    li x10 1234             #store word
    li x5 0                 #count of 1
    li x4 0                 #count of 0
    li x6 32                #no of bits
    jal x2 loop

    loop:
        beq x6 x0 exit      #exit loop
        andi x7 x10 1       #do and op
        beq x7 x0 skip      #skip if bit is 0
        addi x5 x5 1        #increment counter
    
    skip:
        srli x10 x10 1      #shift right by one
        addi x6 x6 -1       #decrement iterator
        j loop              #jump to loop back

exit:
    li x10 32
    sub x4 x10 x5
    li x17 10
    ecall