.global main

N0 = 3
N1 = 2

main:
    adr     x19, tab            //
    mov     x20, 0              // i = 0
                                //
prochaineLigne:                 // do {
    mov     x21, 0              //   j = 0
                                //
afficherLigne:                  //   do {
    adr     x0, fmtElem         //
    ldrh    w1, [x19], 2        //
    bl      printf              //     afficher tab[i, j]
                                //
    add     x21, x21, 1         //     j++
    cmp     x21, N1             //   }
    b.lo    afficherLigne       //   while (j < N1)
                                //
    adr     x0, fmtSaut         //
    bl      printf              //   afficher saut de ligne
                                //
    add     x20, x20, 1         //   i++
    cmp     x20, N0             // }
    b.lo    prochaineLigne      // while (i < N0)

    mov     x0, 0
    bl      exit

.section ".data"
tab:        .hword  2, 33, 65535, 73, 9000, 255

.section ".rodata"
fmtElem:    .asciz  "%u "
fmtSaut:    .asciz  "\n"
