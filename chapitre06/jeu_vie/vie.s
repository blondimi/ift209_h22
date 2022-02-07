.global main

main:                           //
    mov     x28, 8              //
                                //
    // Lire une grille          //
lecture:                        //
    //  Lire nombre de lignes   //
    adr     x0, fmtEntree       //
    adr     x1, temp            //
    bl      scanf               // scanf("%lu", &temp)
    ldr     x19, temp           // m = temp
                                //
    //  Lire nombre de colonnes //
    adr     x0, fmtEntree       //
    adr     x1, temp            //
    bl      scanf               // scanf("%lu", &temp)
    ldr     x20, temp           // n = temp
                                //
    //  Lire contenu            //
    mul     x24, x19, x20       // k = m * n
    adr     x25, grille         // adr = &grille
lecture_boucle:                 //
    cbz     x24, generer_grille // while (k != 0) {
    adr     x0, fmtEntree       //
    mov     x1, x25             //
    bl      scanf               //   scanf("%lu", adr)
    sub     x24, x24, 1         //   k--
    add     x25, x25, 8         //   adr += 8
    b       lecture_boucle      // }
                                //
    // Générer nouvelle grille  //
generer_grille:                 //
    mov     x21, 0              // i = 0
generer_boucle_i:               //
    cmp     x21, x19            //
    b.eq    fin                 // while (i != m) {
    mov     x22, 0              //   j = 0
generer_boucle_j:               //
    cmp     x22, x20            //
    b.eq    generer_prochain_i  //   while (j != n) {
                                //
compter_voisins:                //     // Compter # voisins vivants de (i, j)
    mov     x23, 0              //     num_voisins = 0
                                //
    mul     x24, x21, x20       //
    sub     x24, x24, x20       //
    add     x24, x24, x22       //
    mul     x24, x28, x24       //     index = 8*((i - 1) * n + j)
    adr     x25, grille         //
    add     x25, x25, x24       //     adr = &grille + index
                                //
    //  Explorer voisins        //
ligne_haut:                     //
    cbz     x21, ligne_centre   //     if (i != 0) {
haut_gauche:                    //
    cbz     x22, haut           //       if (j != 0) {
    ldr     x24, [x25, -8]      //
    add     x23, x23, x24       //         num_voisins += *(adr - 8)
haut:                           //       }
    ldr     x24, [x25]          //
    add     x23, x23, x24       //       num_voisins += *adr
haut_droite:                    //
    add     x24, x22, 1         //
    cmp     x24, x20            //
    b.eq    ligne_centre        //       if (j + 1 != n) {
    ldr     x24, [x25, 8]       //
    add     x23, x23, x24       //         num_voisins += *(adr + 8)
ligne_centre:                   //       }
    mul     x24, x28, x20       //     }
    add     x25, x25, x24       //     adr += 8*n     // passer à ligne suivante
centre_gauche:                  //
    cbz     x22, centre_droite  //     if (j != 0) {
    ldr     x24, [x25, -8]      //
    add     x23, x23, x24       //       num_voisins += *(adr - 8)
centre_droite:                  //     }
    add     x24, x22, 1         //
    cmp     x24, x20            //
    b.eq    ligne_bas           //     if (j + 1 != n) {
    ldr     x24, [x25, 8]       //
    add     x23, x23, x24       //       num_voisins  += *(adr + 8)
ligne_bas:                      //     }
    mul     x24, x28, x20       //
    add     x25, x25, x24       //     adr += 8*n     // passer à ligne suivante
    add     x24, x21, 1         //
    cmp     x24, x19            //
    b.eq    fin_voisins         //     if (i + 1 != m) {
bas_gauche:                     //
    cbz     x22, bas            //       if (j != 0) {
    ldr     x24, [x25, -8]      //
    add     x23, x23, x24       //         num_voisins += *(adr - 8)
bas:                            //       }
    ldr     x24, [x25]          //
    add     x23, x23, x24       //       num_voisins += *adr
bas_droite:                     //
    add     x24, x22, 1         //
    cmp     x24, x20            //
    b.eq    fin_voisins         //       if (j + 1 != n) {
    ldr     x24, [x25, 8]       //
    add     x23, x23, x24       //         num_voisins += *(adr + 8)
fin_voisins:                    //       }
                                //     }
    // Déterminer nouvel état   //
    mul     x24, x28, x20       //
    sub     x25, x25, x24       //     adr -= 8*n   // retour à ligne précédente
                                //
    cmp     x23, 3              //     // Nouvel état de la cellule?
    b.eq    cellule_vivante     //     if !(num_voisins == 3 ||
    ldr     x24, [x25]          //
    cbz     x24, cellule_morte  //           (*adr == 1 &&
    cmp     x23, 2              //            num_voisins == 2)) {
    b.eq    cellule_vivante     //
cellule_morte:                  //
    mov     x1, 0               //       etat = 0
    b       afficher_cellule    //     }
cellule_vivante:                //     else {
    mov     x1, 1               //       etat = 1
                                //     }
    // Afficher nouvel état     //
afficher_cellule:               //
    adr     x0, fmtSortie       //
    bl      printf              //     printf("%lu ", etat)
                                //
    add     x22, x22, 1         //     j++
    b       generer_boucle_j    //   }
generer_prochain_i:             //
    adr     x0, fmtSaut         //
    bl      printf              //   printf("\n")
                                //
    add     x21, x21, 1         //   i++
    b       generer_boucle_i    // }
                                //
fin:                            //
    mov     x0, 0               //
    bl      exit                //

.section ".rodata"
fmtEntree:  .asciz  "%lu"
fmtSortie:  .asciz  "%lu "
fmtSaut:    .asciz  "\n"

.section ".bss"
            .align  8
temp:       .skip   8
grille:     .skip   80000
