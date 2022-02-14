.global main

// Lit 10 caractères et les stocke dans tab
main:                     //
    adr   x19, tab        //
    mov   x20, 0          // i = 0
                          //
boucle:                   //
    cmp   x20, 10         // while (i != 0) {
    b.eq  fin             //
                          //
    adr   x0, fmtChar     //
    adr   x1, temp        //
    bl    scanf           //   scanf(" %c", &temp)
    adr   x22, temp       //
    ldrb  w21, [x22]      //   c = temp
                          //
    str   x21, [x19, x20] //   tab[i] = c  // Stockage d'un octet sur 8 octets!
                          //
    add   x20, x20, 1     //   i++
    b     boucle          // }
                          //
fin:                      //
    mov   x0, 0           //
    bl    exit            // exit(0)

.section ".rodata"
fmtChar:  .asciz  " %c"

.section ".bss"
temp:     .skip   1
tab:      .skip   17
