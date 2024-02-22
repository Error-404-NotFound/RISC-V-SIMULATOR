.data
array: .word 10 20 30 40
str: .string "Hello"
str2: .string "ABCDEFG"
array2: .word 1 2 3 4 5 6 7 8 9 10
    
.text
    li x1 0     #i
    li x2 5     #n
    li x3 0     #j
    li x6 0     #sum
    beq x1 x2 loop
    li x5 23

loop: 
    add x1 x2 x3
    

