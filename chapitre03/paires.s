.global main

// Exemple de boucles imbriquées
//
// Entrée: aucune (valeur figées dans m et n)
// Sortie: toutes les paires (i, j) où 0 ≤ i < m et 0 ≤ j < n
// Usage des registres:
//   x19 -- m
//   x20 -- n
//   x21 -- i
//   x22 -- j
main:
        // Valeurs de m et n (figées)       //
        mov   x19, 3                        // m = 3
        mov   x20, 4                        // n = 4
                                            //
        mov   x21, 0                        // i = 0
loopi:                                      //
        mov   x22, 0                        // j = 0
loopj:                                      //
        // Afficher (i, j)                  //
        adr   x0, fmtPaire                  // arg0 = &fmtPaire
        mov   x1, x21                       // arg1 = i
        mov   x2, x22                       // arg2 = j
        bl    printf                        // printf(arg0, arg1, arg2)
                                            //
        add   x22, x22, 1                   // j++
        cmp   x22, x20                      //
        b.lo  loopj                         // if (j < n) goto loopj
                                            //
        add   x21, x21, 1                   // i++
        cmp   x21, x19                      //
        b.lo  loopi                         // if (i < m) goto loopi
                                            //
        mov   x0, 0                         //
        bl    exit                          // quitter le programme

.section ".rodata"
fmtPaire:     .asciz  "(%lu, %lu)\n"
