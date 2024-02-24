.data
    array: .word 3 3 4 3
    str: .string "Final array: "


.text
    li x1 1
    add x2 x1 x1
    srli x2 x2 -1
    li x3 1
    beq x1 x3 exit
    li x7 200
exit:
    li x7 100