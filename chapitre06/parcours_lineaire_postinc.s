.global main

N0 = 3
N1 = 2

main:
    adr     x19, tab            //
    mov     x20, 0              // i = 0
afficher:                       // do {
    adr     x0, fmt             //
    ldrh    w1, [x19], 2        //
    bl      printf              //   afficher tab[i]
                                //
    add     x20, x20, 1         //   i++
    cmp     x20, N0*N1          // }
    b.lo    afficher            // while (i < N0*N1)

    mov     x0, 0
    bl      exit

.section ".data"
tab:    .hword   2, 33, 65535, 73, 9000, 255

.section ".rodata"
fmt:    .asciz  "%u\n"
