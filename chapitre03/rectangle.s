.global main

// Calcule l'aire et le périmètre d'un rectangle
//
// Entrée: lit quatre entiers non négatifs de 64 bits: x1, y1, x2, y2
// Sortie: aire et périmètre d'un rectangle dont deux coins opposés
//         sont donnés par (x1, y1) et (x2, y2)
// Usage des registres:
//   x19 -- x1         x23 -- distX
//   x20 -- y1         x24 -- distY
//   x21 -- x2         x25 -- aire
//   x22 -- y2         x26 -- perimetre
main:
    // Lire x1
    adr   x0, fmtNombre                 // arg0 = &fmtNombre
    adr   x1, temp                      // arg1 = &temp
    bl    scanf                         // scanf(arg0, arg1)
    ldr   x19, temp                     // x1 = mem[temp]
                                        //
    // Lire y1                          //
    adr   x0, fmtNombre                 // arg0 = &fmtNombre
    adr   x1, temp                      // arg1 = &temp
    bl    scanf                         // scanf(arg0, arg1)
    ldr   x20, temp                     // y1 = mem[temp]
                                        //
    // Lire x2                          //
    adr   x0, fmtNombre                 // arg0 = &fmtNombre
    adr   x1, temp                      // arg1 = &temp
    bl    scanf                         // scanf(arg0, arg1)
    ldr   x21, temp                     // x2 = mem[temp]
                                        //
    // Lire y2                          //
    adr   x0, fmtNombre                 // arg0 = &fmtNombre
    adr   x1, temp                      // arg1 = &temp
    bl    scanf                         // scanf(arg0, arg1)
    ldr   x22, temp                     // y2 = mem[temp]
                                        //
    // Calculer distance horizontale    //
    cmp   x19, x21                      //
    b.lo  main100                       // if (x1 < x2) goto main100
    sub   x23, x19, x21                 // else { distX = x1 - x2
    b     main200                       //        goto main200 }
main100:                                //
    sub   x23, x21, x19                 // distX = x2 - x1
                                        //
main200:                                //
    // Calculer distance verticale      //
    cmp   x20, x22                      //
    b.lo  main300                       // if (y1 < y2) goto main300
    sub   x24, x20, x22                 // else { distY = y1 - y2
    b     main400                       //        goto main400 }
main300:                                //
    sub   x24, x22, x20                 // distY = y2 - y1
                                        //
main400:                                //
    // Calculer aire                    //
    mul   x25, x23, x24                 // aire = distX * distY
                                        //
    // Afficher aire                    //
    adr   x0, msgAire                   // arg0 = &msgAire
    mov   x1, x25                       // arg1 = aire
    bl    printf                        // printf(arg0, arg1)
                                        //
    // Calculer périmètre               //
    add   x26, x23, x23                 // perimetre  = 2*distX
    add   x26, x26, x24                 // perimetre += distY
    add   x26, x26, x24                 // perimetre += distY
                                        //
    // Afficher périmètre               //
    adr   x0, msgPerim                  // arg0 = &msgPerim
    mov   x1, x26                       // arg1 = perimetre
    bl    printf                        // printf(arg0, arg1)
                                        //
    mov   x0, 0                         //
    bl    exit                          // quitter le programme

.section ".bss"
              .align  8
temp:         .skip   8

.section ".rodata"
fmtNombre:    .asciz  "%lu"
msgAire:      .asciz  "Aire: %lu\n"
msgPerim:     .asciz  "Périmètre: %lu\n"
