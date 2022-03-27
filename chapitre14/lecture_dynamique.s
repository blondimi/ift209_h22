.global main

.macro SAVE
  stp   x29, x30, [sp, -96]!
  mov   x29, sp
  stp   x27, x28, [sp, 16]
  stp   x25, x26, [sp, 32]
  stp   x23, x24, [sp, 48]
  stp   x21, x22, [sp, 64]
  stp   x19, x20, [sp, 80]
.endm

.macro RESTORE
  ldp   x27, x28, [sp, 16]
  ldp   x25, x26, [sp, 32]
  ldp   x23, x24, [sp, 48]
  ldp   x21, x22, [sp, 64]
  ldp   x19, x20, [sp, 80]
  ldp   x29, x30, [sp], 96
.endm

/*******************************************************************************
  Exemple de lecture d'une chaîne de taille arbitraire avec appels systèmes
*******************************************************************************/
main:                                   // main()
    // Lire une chaîne au clavier       // {
    bl      lire                        //   chaine, taille = lire()
    mov     x19, x0                     //
    mov     x20, x1                     //
                                        //
    // Afficher chaîne et sa taille     //
    adr     x0, fmtSortie               //
    mov     x1, x19                     //
    mov     x2, x20                     //
    bl      printf                      //   printf(&fmtSortie, chaine, taille)
                                        //
    mov     x0, 0                       //
    bl      exit                        //   return 0
                                        // }
/*******************************************************************************
 Entrée: nombre d'octets n ≥ 1 à allouer
 Sortie: adresse de la mémoire allouée
*******************************************************************************/
allouer:                                // allouer(n)
    mov     x9, x0                      // {
                                        //
    // Obtenir l'adresse du tas         //
    mov     x8, 214                     //   /* brk = 214 */
    mov     x0, 0                       //
    svc     0                           //
    mov     x10, x0                     //   a = brk(0)
                                        //
    // Incrémenter l'adresse du tas     //
    mov     x8, 214                     //
    add     x0, x10, x9                 //
    svc     0                           //   brk(a + n)
                                        //
    mov     x0, x10                     //
    ret                                 //   return a
                                        // }
/*******************************************************************************
 Entrée: aucune
 Effet: - lit une chaîne de caractères s du flux d'entrée standard jusqu'à
          un retour de ligne
        - stocke s en mémoire terminée par un caractère nul
 Sortie: adresse de s et le nombre d'octets de s (sans le car. nul)
*******************************************************************************/
.section ".bss"                         //
                .align  16              //
_lire_tampon:   .skip   16              // allouer tampon[16]
                                        //
.section ".text"                        //
lire:                                   // lire()
    SAVE                                // {
    adr     x19, _lire_tampon           //
                                        //
    mov     x20, 0                      //   i = 0
    mov     x22, 0                      //   j = 0
_lire_boucle:                           //
    // Lire un octet                    //   do {
    mov     x8, 63                      //     /* read  = 63
    mov     x0, 0                       //        stdin = 0  */
    add     x1, x19, x22                //
    mov     x2, 1                       //
    svc     0                           //     read(stdin, tampon[j], 1)
                                        //
    // Fin de la lecture?               //
    ldrb    w21, [x19, x22]             //     /* 10 = saut de ligne '\n' */
    cmp     w21, 10                     //     if (tampon[j] == 10)
    b.eq    _lire_copier                //       break
                                        //
    add     x22, x22, 1                 //     j++
                                        //
    // Empiler le tampon s'il est plein //
    cmp     x22, 16                     //
    b.ne    _lire_continuer             //     if (j == 16) {
    mov     x22, 0                      //       j = 0
    add     x20, x20, 1                 //       i++
    ldp     x23, x24, [x19]             //
    stp     x23, x24, [sp, -16]!        //       empiler tampon
_lire_continuer:                        //     }
    b       _lire_boucle                //   }
                                        //
    // Allouer de la mémoire sur le tas //
_lire_copier:                           //
    lsl     x21, x20, 4                 //
    add     x21, x21, x22               //   taille = 16*i + j
    add     x0, x21, 1                  //
    bl      allouer                     //
    mov     x25, x0                     //   chaine = allouer(taille + 1)
                                        //
    // Dépiler la chaîne vers le tas    //
    add     x19, x25, x20, lsl 4        //
_lire_copier_pile:                      //
    cbz     x20, _lire_copier_continuer //   while (i != 0) {
    ldp     x23, x24, [sp], 16          //     dépiler y, x
    str     x24, [x19, -8]!             //     chaine[16*i - 8]  = y
    str     x23, [x19, -8]!             //     chaine[16*i - 16] = x
    sub     x20, x20, 1                 //     i--
    b       _lire_copier_pile           //   }
                                        //
    // Compléter chaîne avec le tampon  //
_lire_copier_continuer:                 //
    add     x19, x25, x21               //
    sub     x19, x19, x22               //
    adr     x23, _lire_tampon           //   k = j
_lire_copier_tampon:                    //
    cbz     x22, _lire_fin              //   while (j != 0) {
    ldrb    w24, [x23], 1               //     x = tampon[k - j]
    strb    w24, [x19], 1               //     chaine[taille - j] = x
    sub     x22, x22, 1                 //     j--
    b       _lire_copier_tampon         //   }
                                        //
    // Ajouter car. nul et retourner    //
_lire_fin:                              //
    strb    wzr, [x25, x21]             //   chaine[taille] = 0
    mov     x0, x25                     //
    mov     x1, x21                     //
    RESTORE                             //
    ret                                 //   return (chaine, taille)
                                        // }

.section ".rodata"
fmtSortie:  .asciz  "Chaîne lue: %s\nTaille de la chaîne: %lu\n"
