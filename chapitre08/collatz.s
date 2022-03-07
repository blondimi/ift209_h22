.include "macros_save_restore.s"
.global main

/*******************************************************************************
  Modularisation du code de calcul du temps de vol (séquence de Collatz)
*******************************************************************************/
main:                                  // main()
        // Lecture de n                // {
        adr     x0, fmtEntree          //
        adr     x1, temp               //
        bl      scanf                  //   scanf(&fmtEntree, &temp)
        ldr     x19, temp              //   n = temp
                                       //
        // Calcul du temps de vol      //
        mov     x0, x19                //
        bl      collatz                //
        mov     x20, x0                //   temps_vol = collatz(n)
                                       //
        // Affichage du temps de vol   //
        adr     x0, fmtSortie          //
        mov     x1, x20                //
        bl      printf                 //   printf(&fmtSortie, temps_vol)
                                       //
        mov     x0, 0                  //
        bl      exit                   //   exit(0)
                                       // }
                                       //
/*******************************************************************************
 Entrée: entier non signé de 64 bits n
 Sortie: temps de vol de n (selon la séquence de Collatz)
 Usage: x0  -- i     x19 -- n     x20 -- constantes
*******************************************************************************/
collatz:                               // unsigned long collatz(unsigned long n)
        SAVE                           // {
        mov     x19, x0                //
        mov     x0, 0                  //   i = 0
collatz_boucle:                        //
        cmp     x19, 1                 //
        b.eq    collatz_ret            //   while (n != 1) {
        add     x0, x0, 1              //     i++
                                       //
        // Calcul de f(n)              //
        tbnz    x19, 0, collatz_impair //     if (n % 2 == 0) {
collatz_pair:                          //
        mov     x20, 2                 //
        udiv    x19, x19, x20          //       n /= 2
        b       collatz_prochaine_iter //     }
collatz_impair:                        //     else {
        mov     x20, 3                 //
        mul     x20, x20, x19          //
        add     x19, x20, 1            //       n = 3*n + 1
collatz_prochaine_iter:                //     }
        b       collatz_boucle         //   }
collatz_ret:                           //
        ret                            //   return i
                                       // }
.section ".bss"
           .align  8
temp:      .skip   8

.section ".rodata"
fmtEntree: .asciz    "%lu"
fmtSortie: .asciz    "%lu\n"
