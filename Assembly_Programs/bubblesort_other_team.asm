.data
arr:  .word 20,19,18,17,16,15,14,13,12,11,10,9,8,7,6,5,4,3,2,1 
str3: .string "\\n"
str4: .string " "
size: .word 20               

.text
li x23 20 
la x20,arr

addi x21,x23,-2
slli x21,x21,2
add x21,x20,x21

mv x5,x20
li x12,0

li x4 20
addi x6,x4,1
jal x1, bubblesort


swap:
    sw x10,4(x13)
    sw x11,0(x13)
    j j_increment
    
j_increment:  
    addi x13,x13,4
    j check
    
check:
    lw x10,0(x13)
    lw x11,4(x13)
    blt x21,x13, bubblesort
    blt x11,x10, swap
    blt x13,x21 j_increment
    j bubblesort
    
bubblesort:
    mv x5,x20
    beq x12,x23,exit
    addi x12,x12,1
    mv x13,x20
    j check
 
exit:
    li x31,100