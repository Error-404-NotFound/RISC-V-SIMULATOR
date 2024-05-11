.data
    arr: .word 1 2 3 4 5 6 7 8 9 10

.text
main:
    li a0 10
    li a1 20
    jal x30 addition
    jal x31 subt
    jal x29 end
    li a4 50

addition:
    add a0 a0 a1
    jr x30
    li a5 100

subt:
    sub a0 a0 a1
    jr x31
    li a6 200

end:
    li a7 300