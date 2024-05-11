.data 


.text
    addi x10 x0 10      #g
    addi x11 x0 5       #h
    add x10 x10 x11
    addi x12 x0 2       #i
    li x13 3            #j
    add x12 x12 x13     
    sub x10 x10 x12     #f=(g+h)-(i+j)