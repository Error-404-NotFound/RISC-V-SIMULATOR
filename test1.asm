.data
array: .word 10 20 30 40
str: .string "Hello"
str2: .string "ABCDEFG"
array2: .word 1 2 3 4 5 6 7 8 9 10
    
.text
    li x1 1
    li x2 2
    jal x3 loop
    li x5 200

loop: 
    li x5 100
    

