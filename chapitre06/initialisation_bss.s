.global main

N0 = 3
N1 = 2

main:
    adr     x19, tab            //
    mov     w20, 2              //
    strh    w20, [x19], 2       // tab[0] = 2
    mov     w20, 33             //
    strh    w20, [x19], 2       // tab[1] = 33
    mov     w20, 65535          //
    strh    w20, [x19], 2       // tab[2] = 65535
    mov     w20, 73             //
    strh    w20, [x19], 2       // tab[3] = 73
    mov     w20, 9000           //
    strh    w20, [x19], 2       // tab[4] = 9000
    mov     w20, 255            //
    strh    w20, [x19]          // tab[5] = 255

    mov     x0, 0
    bl      exit

.section ".bss"
        .skip  2
tab:    .skip  N0*N1*2          // n0 · n1 · 2 octets
