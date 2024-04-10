.data
    arr: .word 1 2 3 4

.text
    li a0 2049
    li a1 2053
    lb a2 0(a0)
    lb a3 0(a1)