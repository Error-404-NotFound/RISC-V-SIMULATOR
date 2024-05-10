.data
    arr: .word 3,4,1,5,6,7,8,9,2,10
    size: .word 10

.text
    li a0 2052
    lb a1 0(a0)
    lb a2 -4(a0)