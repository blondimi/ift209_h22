.include "macros.s"                 // "
.global main

/*******************************************************************************
  Lit une chaîne ASCII, puis indique sa taille et si elle est un palindrome
*******************************************************************************/
main:                               // main()
    // Lire chaîne                  //
    adr     x0, fmtLecture          // {
    adr     x1, chaine              //
    bl      scanf                   //   scanf(&fmtLecture, &chaine)
                                    //
    // Calculer sa taille           //
    adr     x0, chaine              //
    bl      taille                  //
    mov     x19, x0                 //   n = taille(&chaine)
                                    //
    // Afficher sa taille           //
    adr     x0, msgTaille           //
    mov     x1, x19                 //
    bl      printf                  //   printf(&fmtSortie, n)
                                    //
    // Déterminer si palindrome     //
    adr     x0, chaine              //
    mov     x1, x19                 //
    bl      est_palindrome          //
    mov     x20, x0                 //   pal = est_palindrome(&chaine, n)
                                    //
    // Afficher si palindrome       //
    cbz     x20, main_pas_pal       //
main_est_pal:                       //   if (pal) {
    adr     x0, msgPal              //     msg = &msgPal
    b       main_afficher_pal       //   }
main_pas_pal:                       //   else {
    adr     x0, msgPasPal           //     msg = &msgPasPal
main_afficher_pal:                  //   }
    bl      printf                  //   printf(msg)
                                    //
    // Terminer le programme        //
    mov     x0, 0                   //
    bl      exit                    //   return 0
                                    // }
/*******************************************************************************
  Entrée: adresse d'une chaîne de caractères sous codage ASCII
  Sortie: taille de la chaîne (excluant son caractère nul)
  Usage:  x19 - chaine     x20 - n (compteur)     w21 - caractère actuel
*******************************************************************************/
taille:                             // taille(chaine)
    SAVE                            // {
    mov     x19, x0                 //
    mov     x20, 0                  //   n = 0
taille_boucle:                      //
    ldrb    w21, [x19], 1           //   while (*chaine != 0) {
    cbz     w21, taille_ret         //     chaine++
    add     x20, x20, 1             //     n++
    b       taille_boucle           //   }
taille_ret:                         //
    mov     x0, x20                 //
    RESTORE                         //
    ret                             //   return n
                                    // }
/*******************************************************************************
  Entrée: adresse d'une chaîne de caractères sous codage ASCII et sa taille
  Sortie: 1 si la chaîne est un palindrome, 0 sinon
  Usage:  x19 - chaine                x22 - r (valeur retour)
          x20 - i (indice gauche)     w23 - caractère actuel de gauche
          x21 - j (indice droite)     w24 - caractère actuel de droite
*******************************************************************************/
est_palindrome:                     // est_palindrome(chaine, taille)
    SAVE                            // {
    mov     x19, x0                 //
    mov     x20, 0                  //   i = 0
    sub     x21, x1, 1              //   j = taille - 1
    mov     x22, 1                  //   r = true
                                    //
    cbz     x1, est_palindrome_ret  //   if (taille == 0)
                                    //     return r
est_palindrome_boucle:              //
    cmp     x20, x21                //   while (i < j)
    b.hs    est_palindrome_ret      //   {
                                    //
    ldrb    w23, [x19, x20]         //
    ldrb    w24, [x19, x21]         //
    cmp     w23, w24                //     if (chaine[i] != chaine[j])
    b.eq    est_palindrome_suiv     //     {
    mov     x22, 0                  //       r = false
    b       est_palindrome_ret      //       break
                                    //     }
est_palindrome_suiv:                //
    add     x20, x20, 1             //     i++
    sub     x21, x21, 1             //     j--
    b       est_palindrome_boucle   //   }
est_palindrome_ret:                 //
    mov     x0, x22                 //
    RESTORE                         //
    ret                             //   return r
                                    // }

// Données statiques
.section ".data"
chaine:     .skip 1024

.section ".rodata"
msgTaille:  .asciz  "Taille de la chaîne: %lu\n"
msgPal:     .asciz  "La chaîne est un palindrome.\n"
msgPasPal:  .asciz  "La chaîne n'est pas un palindrome.\n"
fmtLecture: .asciz  "%[^\n]s"       // Format pour lire une chaîne de caractères
                                    // d'une ligne (incluant des espaces)
