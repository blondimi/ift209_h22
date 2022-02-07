.global main

main:
    mov     x0, 0
    bl      exit

.section ".data"
tab:    .hword  2, 33, 65535, 73, 9000, 255
