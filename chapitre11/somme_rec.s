.include "macros.s"                 // "
.global main

/*******************************************************************************
  Lit un entier n ≥ 0 et affiche la somme 1 + 2 + ... + n
*******************************************************************************/
main:                               // main()
    // Lire n                       // {
    adr     x0, fmtLecture          //
    adr     x1, temp                //
    bl      scanf                   //   scanf(&fmtLecture, &temp)
    ldr     x19, temp               //   n = temp
                                    //
    // Calculer la somme            //
    mov     x0, x19                 //
    bl      somme                   //
    mov     x20, x0                 //   m = somme(n)
                                    //
    // Afficher la somme            //
    adr     x0, msgSortie           //
    mov     x1, x19                 //
    mov     x2, x20                 //
    bl      printf                  //   printf(&msgSortie, n, m)
                                    //
    // Terminer le programme        //
    mov     x0, 0                   //
    bl      exit                    //   return 0
                                    // }
/*******************************************************************************
  Entrée: entier n ≥ 0 de 64 bits
  Sortie: 1 + ... + n
  Usage:  x19 - k (var. temporaire)
*******************************************************************************/
somme:                              // somme(n)
    SAVE                            // {
    cbz     x0, somme_ret           //   if (n != 0)
                                    //   {
    mov     x19, x0                 //     k  = n
    sub     x0, x0, 1               //
    bl      somme                   //     n  = somme(n - 1)
    add     x0, x0, x19             //     n += k
somme_ret:                          //   }
    RESTORE                         //
    ret                             //   return n
                                    // }

.section ".data"
            .align  8
temp:       .skip   8

.section ".rodata"
fmtLecture: .asciz  "%lu"
msgSortie:  .asciz  "1 + ... + %lu = %lu\n"
