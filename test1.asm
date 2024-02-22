.data
array: .word 10 20 -30 40
str: .string "Hello"
str2: .string "ABCDEFG"
array2: .word 1 2 3 4 5 6 7 8 9 10
    
.text
    li x1 5
    li x2 134
    jal x5 addition
    jal x6 subtraction
    li x7 139
    beq x3 x7 end
    li x8 300

addition:
    add x3 x1 x2
    jr x5
    li x8 300

subtraction:
    sub x4 x1 x2
    jr x6
    li x8 300
    
end:
    li x8 200
