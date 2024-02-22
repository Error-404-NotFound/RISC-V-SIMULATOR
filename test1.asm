.data
array: .word 10 20 30 40
str: .string "Hello"
str2: .string "ABCDEFG"
array2: .word 1 2 3 4 5 6 7 8 9 10
    
.text
    li x1 5
    li x2 134
    sw x2 0(x1)
    add x3 x1 x2
    lw x3 0(x1)