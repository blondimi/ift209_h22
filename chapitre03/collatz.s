// Pour assembler et exécuter sur Ubuntu:
//
// as collatz.s -o collatz.o && ld collatz.o -o collatz -e main -lc && ./collatz
//
.global main
  
main:  
        // Lecture de n
        adr     x0, fmtEntree   // x0 ← adresse(fmtEntree)
        adr     x1, temp        // x1 ← adresse(temp)
        bl      scanf           // scanf(x0, x1)

        ldr     x19, temp       // x19 ← mem[temp]

        // Calcul du temps de vol
        mov     x21, 0          // x21 ← 0
boucle:
        cmp     x19, 1          //
        b.eq    finboucle       // si n = 1: aller à finboucle
        add     x21, x21, 1     // sinon: incrémenter x21

        // Calcul de f(x19)
        tbnz    x19, 0, impair  // si x19[0] ≠ 0: aller à impair
pair:
        mov     x20, 2          // x20 ← 2
        udiv    x19, x19, x20   // x19 ← x19 ÷ x20
        b       fin             // aller à fin
impair:
        mov     x20, 3          // x20 ← 3
        mul     x20, x20, x19   // x20 ← x20 * x19
        add     x19, x20, 1     // x19 ← x20 + 1
fin:

        b       boucle          // aller à boucle
finboucle:
        
        // Affichage du temps de vol
        adr     x0, msgRes      // x0 ← adresse(msgRes)
        mov     x1, x21         // x1 ← x21
        bl      printf          // printf(x0, x1)

        mov     x0, 0           //
        bl      exit            // Quitter le programme

.section ".bss"
           .align  8
temp:      .skip   8        

.section ".rodata"
fmtEntree: .asciz    "%lu"
msgRes:    .asciz    "Résultat: %lu"
