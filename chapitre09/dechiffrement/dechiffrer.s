.include "macros.s"
.global main

/*******************************************************************************
  Déchiffrement de clés stockées sous forme d'images au format PBM
                        (variante de cryptographie visuelle avec masque jetable)

  Usage: x19 - m (# pixels/ligne)    x20 - n (# pixels/colonne)
*******************************************************************************/
main:                               // main()
    // Charger les clés secrètes    // {
    adr     x0, imgCle1             //
    bl      charger                 //
    mov     x19, x0                 //
    mov     x20, x1                 //   m, n = charger(&imgCle1)
                                    //
    adr     x0, imgCle2             //
    bl      charger                 //   _, _ = charger(&imgCle2)
                                    //
    // Construire l'image chiffrée  //
    adr     x0, imgCle1             //
    adr     x1, imgCle2             //
    adr     x2, imgSortie           //
    mov     x3, x19                 //
    mov     x4, x20                 //
    bl      dechiffrer              //   dechiffrer(&imgCle1, &imgCle2,
                                    //              &imgSortie, m, n)
    // Afficher l'image déchiffrée  //
    adr     x0, imgSortie           //
    mov     x1, x19                 //
    mov     x2, x20                 //
    bl      afficher                //   afficher(&imgSortie, m, n)
                                    //
    // Quitter                      //
    mov     x0, 0                   //
    bl      exit                    //   return 0
                                    // }
/*******************************************************************************
  Entrée: img: adresse où stocker une image
  Effet:  lit une image au format PBM et stocke son contenu vers img
  Sortie: (m, n): dimension de l'image en pixels
  Usage: x19 - img     x20 - m (# pixels/ligne)     x21 - n  (# pixels/colonne)
         x22 - num_pixels
*******************************************************************************/
charger:                            // charger(img)
    SAVE                            // {
    mov     x19, x0                 //
                                    //
    // Lire/ignorer en-tête "P4"    //
    adr     x0, fmtChar             //
    adr     x1, tmpOctet            //
    bl      scanf                   //   scanf("%c", &tmpOctet)
                                    //
    adr     x0, fmtChar             //
    adr     x1, tmpOctet            //
    bl      scanf                   //   scanf("%c", &tmpOctet)
                                    //
    // Lire dimension de l'image    //
    adr     x0, fmtNum              //
    adr     x1, tmpNum              //
    bl      scanf                   //   scanf("%ld", &tempNum)
    ldr     x21, tmpNum             //   n = tempNum
                                    //
    adr     x0, fmtNum              //
    adr     x1, tmpNum              //
    bl      scanf                   //   scanf("%ld", &tempNum)
    ldr     x20, tmpNum             //   m = tempNum
                                    //
    // Lire/ignorer saut de ligne   //
    adr     x0, fmtChar             //
    adr     x1, tmpOctet            //
    bl      scanf                   //   scanf("%c", &tmpOctet)
                                    //
    // Lire chaque pixel            //
    add     x22, x21, 7             //
    lsr     x22, x22, 3             //
    mul     x22, x20, x22           //   num_pixels = m * ((n + 7) / 8)
charger_boucle:                     //
    cbz     x22, charger_ret        //   while (num_pixels != 0)
                                    //   {
    adr     x0, fmtChar             //
    mov     x1, x19                 //
    bl      scanf                   //     scanf("%c", img)
                                    //
    add     x19, x19, 1             //     img++
    sub     x22, x22, 1             //     num_pixels--
    b       charger_boucle          //   }
charger_ret:                        //
    mov     x0, x20                 //
    mov     x1, x21                 //
    RESTORE                         //
    ret                             //   return (m, n)
                                    // }
/*******************************************************************************
  Entrée: img1:       adresse d'une image contenant la 1ère clé
          img2:       adresse d'une image contenant la 2ème clé
          img_sortie: adresse où stocker l'image déchiffrée
          m:          nombre de pixels sur une ligne de chaque image
          n:          nombre de pixels sur une colonne de chaque image
  Effet:  déchiffre les deux clés et produit leur déchiffrement
  Usage: x19 - num_pixels     w20 - pixel1     w21 - pixel2     w22 - pixel
*******************************************************************************/
dechiffrer:                         // dechiffrer(img1, img2, img_sortie, m, n)
    SAVE                            // {
    add     x19, x4, 7              //
    lsr     x19, x19, 3             //
    mul     x19, x3, x19            //   num_pixels = m * ((n + 7) / 8)
dechiffrer_boucle:                  //
    cbz     x19, dechiffrer_ret     //   while (num_pixels != 0)
                                    //   {
    ldrb    w20, [x0], 1            //     pixel1 = *img1;  img1++
    ldrb    w21, [x1], 1            //     pixel2 = *img2;  img2++
    eor     w22, w20, w21           //     pixel  = pixel1 ⊕ pixel2
                                    //
    strb    w22, [x2], 1            //     *img_sortie = pixel;  img_sortie++
                                    //
    sub     x19, x19, 1             //     num_pixels--
    b       dechiffrer_boucle       //   }
dechiffrer_ret:                     //
    RESTORE                         //
    ret                             // }
                                    //
/*******************************************************************************
  Entrée: img: adresse d'une image
          m:   nombre de pixels sur une ligne de l'image
          n:   nombre de pixels sur une colonne de l'image
  Effet:  affiche le contenu de l'image au format PBM
  Usage: x19 - img      x20 - m (# pixels/ligne)      x21 - n (# pixels/colonne)
         x22 - num_pixels
*******************************************************************************/
afficher:                           // afficher(img, m, n)
    SAVE                            // {
    mov     x19, x0                 //
    mov     x20, x1                 //
    mov     x21, x2                 //
                                    //
    // Afficher en-tête             //
    adr     x0, fmtEntete           //
    bl      printf                  //   printf("P4\n")
                                    //
    // Afficher dimension           //
    adr     x0, fmtTaille           //
    mov     x1, x21                 //
    mov     x2, x20                 //
    bl      printf                  //   printf("%lu %lu\n", n, m)
                                    //
    // Afficher chaque pixel        //
    add     x22, x21, 7             //
    lsr     x22, x22, 3             //
    mul     x22, x20, x22           //   num_pixels = m * ((n + 7) / 8)
afficher_boucle:                    //
    cbz     x22, afficher_ret       //   while (num_pixels != 0)
                                    //   {
    adr     x0, fmtChar             //
    ldrb    w1, [x19], 1            //     pixel = *img;  img++
    bl      printf                  //     printf("%c", pixel)
                                    //
    sub     x22, x22, 1             //     num_pixels--
    b       afficher_boucle         //   }
afficher_ret:                       //
    RESTORE                         //
    ret                             // }

// Données statiques
.section ".rodata"
fmtChar:    .asciz  "%c"
fmtNum:     .asciz  "%lu"
fmtEntete:  .asciz  "P4\n"
fmtTaille:  .asciz  "%lu %lu\n"

.section ".bss"
            .align  8
tmpNum:     .skip   8
tmpOctet:   .skip   1
imgCle1:    .skip   100000
imgCle2:    .skip   100000
imgSortie:  .skip   100000
