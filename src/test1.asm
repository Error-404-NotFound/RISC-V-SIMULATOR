.data
arr: .word 1 2 3

.text
    li a0 10
    li a1 20
    mv a7 a1
    la a5 arr
    jal x30 addition
    jal x31 subt
    jal x29 end
    jal x28 final
addition:
    add a2 a0 a1
    jr x30

subt:
    sub a3 a0 a1
    jr x31

end:
    li a4 100
    jr x29

final:
    li a4 200