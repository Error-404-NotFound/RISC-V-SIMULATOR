.data
    array: .word 10,20,30
    str: .string "Hello, World"

.text
    li x1 5
    li x2 134567
    sw x2 0(x1)
    lw x3 0(x1)