.data
    array: .word 10,20,30
    str: .string "Hello, World"
.text
    li x1 5    
    li x2 100  
    li x3 0
    j loop 
    li x5 200

loop: 
    beq x1 x2 endloop
    addi x1 x1 1
    j loop
    li x5 600

endloop:
    li x5 100