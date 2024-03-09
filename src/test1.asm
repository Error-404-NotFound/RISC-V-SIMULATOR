.data
    arr: .word 1 2 3 4 5 6 7 8 9 10

.text
    li a1 4
    li a2 4
    jal x0 label
    li a6 200

label:
    li a7 100