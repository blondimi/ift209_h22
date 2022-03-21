.global main

/*******************************************************************************
  Affiche la moyenne de valeurs en virgule flottante (double précision)
*******************************************************************************/
main:                               // main()
    adr     x0, valeurs             // {
    mov     x1, 6                   //
    bl      moyenne                 //
    fmov    d8, d0                  //   moy = moyenne(&notes, 6)
                                    //
    adr     x0, fmtSortie           //
    fmov    d0, d8                  //
    bl      printf                  //   printf(&fmtSortie, moy)
                                    //
    mov     x0, 0                   //
    bl      exit                    //   return 0
                                    // }
/*******************************************************************************
  Entrée: adresse d'un tableau de nombres en virgule flottante double précision
          nombre d'éléments du tableau
  Sortie: moyenne des éléments du tableau
  Usage:  x19 - i     d8 - acc     d9 - val     d10 - n (converti en double)
*******************************************************************************/
moyenne:                            // moyenne(tab, n)
    // Préserver registres appelant // {
    stp     x29, x30, [sp, -64]!    //
    mov     x29, sp                 //
    stp     x19, xzr, [sp, 16]      //
    stp     d8, d9,   [sp, 32]      //  /* on empile d9 deux fois simplement
    stp     d9, d10,  [sp, 48]      //     car on ne peut pas utiliser xzr
                                    //     pour remplir le dernier double mot */
    // Calculer moyenne             //
    mov     x19, 0                  //   i   = 0
    fmov    d8, xzr                 //   acc = 0.0  /* xzr car 0 pas supporté */
moyenne_boucle:                     //
    cmp     x19, x1                 //
    b.hs    moyenne_ret             //   while (i < n)
                                    //   {
    ldr     d9, [x0, x19, lsl 3]    //     val  = tab[i];
    fadd    d8, d8, d9              //     acc += val
    add     x19, x19, 1             //     i++
    b       moyenne_boucle          //   }
moyenne_ret:                        //
    ucvtf   d10, x1                 //
    fdiv    d0, d8, d10             //   moy = acc / n
                                    //
    // Restaurer registres appelant //
    ldp     x19, xzr, [sp, 16]      //
    ldp     d8, d9,   [sp, 32]      //
    ldp     d9, d10,  [sp, 48]      //
    ldp     x29, x30, [sp], 64      //
                                    //
    ret                             //   return moy
                                    // }

// Donnée statiques
.section ".data"
            .align  8
valeurs:    .double 10.0, 9.5, 3.75, 8.25, 9.5, 7.75 // valeurs = {10.0, 9.5,
                                                     //            3.75, 8.25,
                                                     //            9.5,  7.75}
.section ".rodata"
fmtSortie:  .asciz  "Moyenne: %lf\n"
