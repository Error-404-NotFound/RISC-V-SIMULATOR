.data

.text
    li a1 10
    li a2 20
    add a3 a1 a2
    j exit

h:
    li a7 10
    ecall

exit:
    li a6 10
    li a7 12
    j h
    