.global main

main:
        // Émulation de l'adressage relatif
        adr     x19, etiq
        ldr     x19, [x19]
        ldr     w19, [x19]

        // Afficher x19 et quitter
        adr     x0, fmtSortie
        mov     x1, x19
        bl      printf
        
        mov     x0, 0
        bl      exit

.section ".rodata"
donnee:         .word   42
etiq:           .xword  donnee
fmtSortie:      .asciz  "%lu\n"
