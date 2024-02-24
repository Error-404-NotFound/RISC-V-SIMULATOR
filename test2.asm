.data
    array: .word 3 3 4 3
    str: .string "abc\n efg"


.text
    
    li x10 4
    li x17 1
    ecall
    la x10 str
    li x17 4
    ecall
    li x17 10
    ecall