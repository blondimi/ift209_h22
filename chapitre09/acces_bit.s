.global main

/*******************************************************************************
  Exemple d'extraction de bits d'un tableau d'octets
*******************************************************************************/
main:                       // main()
    // Afficher bit 5       //
    adr     x0, tab         // {
    mov     x1, 5           //
    bl      acces_bit       //
    mov     x19, x0         //   b = acces_bit(&tab, 5)
                            //
    adr     x0, fmtSortie   //
    mov     x1, x19         //
    bl      printf          //   printf("%u\n", b)
                            //
    // Afficher bit 12      //
    adr     x0, tab         //
    mov     x1, 12          //
    bl      acces_bit       //
    mov     x19, x0         //   b = acces_bit(&tab, 12)
                            //
    adr     x0, fmtSortie   //
    mov     x1, x19         //
    bl      printf          //   printf("%u\n", b)
                            //
    // Afficher bit 24      //
    adr     x0, tab         //
    mov     x1, 24          //
    bl      acces_bit       //
    mov     x19, x0         //   b = acces_bit(&tab, 24)
                            //
    adr     x0, fmtSortie   //
    mov     x1, x19         //
    bl      printf          //   printf("%u\n", b)
                            //
    mov     x0, 0           //
    bl      exit            //   return 0
                            // }
/*******************************************************************************
  Entrée: adresse d'un tableau d'octets et indice i
  Sortie: i-ème bit de tab
  Usage:  x9  - i ÷ 8
          x10 - x (octet contenant le bit)
          x11 - k (position du bit)
*******************************************************************************/
acces_bit:                  // acces_bit(tab, i)
    lsr     x9, x1, 3       // {
    ldrb    w10, [x0, x9]   //   x = tab[i ÷ 8]
    and     x11, x1, 0x07   //   k = i % 8
    eor     x11, x11, 0x07  //   k = 7 - k
    lsr     x10, x10, x11   //   x >>= k
    and     x0, x10, 0x01   //
    ret                     //   return x & 00000001₂
                            // }

.section ".rodata"                         //           bit 5     bit 12
fmtSortie:  .asciz  "%u\n"                 //             v         v
tab:        .byte   0xA7, 0x34, 0x5C, 0x2B // tab = {10100111₂, 00110100₂,
                                           //        01011100₂, 00101011₂}
                                           //                   ^
                                           //                 bit 24
