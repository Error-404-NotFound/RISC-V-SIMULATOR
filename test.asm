.data
    array: .word 10
    str: .string "Hello"

.text
    li x1 5
    li x2 134567
    sw x2 0(x1)
    lw x3 0(x1)