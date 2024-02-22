.data
    
.text
    li x1 0     #i
    li x2 5     #n
    li x3 0     #j
    li x6 0     #sum
    j loop 
    li x5 200

loop: 
    beq x1 x2 endloop
    loop1:
        beq x3 x2 exit
        addi x6 x6 1
        addi x3 x3 1
        j loop1
    
exit:
    addi x1 x1 1
    j loop

endloop:
    li x5 100

