.include "macros.s"
.global  main

// Taille de la grille
NUM_LIGNES   = 6
NUM_COLONNES = 7
NUM_ELEM     = NUM_LIGNES * NUM_COLONNES

/*******************************************************************************
  Implémentation du jeu Puissance 4

  Usage: x19 -- personne
         x20 -- nb_tour
*******************************************************************************/
main:                                   // int main ()
    // Initialiser/afficher grille vide // {
    bl      initialiser                 //   initialiser()
    bl      afficher                    //   afficher()
                                        //
    mov     x19, 2                      //   personne = 2
    mov     x20, 0                      //   nb_tour  = 0
                                        //
main_boucle:                            //   do
    // Faire jouer personne suivante    //   {
    add     x20, x20, 1                 //     nb_tour++
    neg     x19, x19                    //
    add     x19, x19, 3                 //
    mov     x0, x19                     //     personne = -personne + 3
    bl      ajouter_jeton               //     ajouter_jeton(personne)
                                        //
    // Afficher nouvelle grille         //
    bl      afficher                    //     afficher()
                                        //
    // Victoire ou nulle?               //
    bl      victoire                    //     partie_gagnée = victoire()
    cbnz    x0, main_victoire           //   }
    cmp     x20, NUM_ELEM               //   while (!partie_gagnée &&
    b.lo    main_boucle                 //          nb_tour < NUM_ELEM)
                                        //
main_nulle:                             //   if (!partie_gagnée)
    // Afficher partie nulle            //   {
    adr     x0, msgNulle                //
    bl      printf                      //     printf(msgNulle)
    b       main_ret                    //   }
                                        //   else
main_victoire:                          //   {
    // Afficher personne gagnante       //
    adr     x0, msgSucces               //
    mov     x1, x19                     //
    bl      printf                      //     printf(msgSucces, personne)
                                        //   }
main_ret:                               //
    mov     x0, 0                       //
    bl      exit                        //   return 0
                                        // }
                                        //
/*******************************************************************************
 Effet: remplit la grille avec des 0
 Usage: x19 -- i
        x20 -- adr
*******************************************************************************/
initialiser:                            // void initialiser()
    SAVE                                // {
    adr     x20, grille                 //   adr = &grille
    mov     x19, NUM_ELEM               //   i   = NUM_ELEM
initialiser_boucle:                     //
    cbnz    x19, initialiser_fin        //   while (i != 0)
    strb    wzr, [x20], 1               //     *adr = 0; adr++
    sub     x19, x19, 1                 //     i--
    b       initialiser_boucle          //   }
initialiser_fin:                        //
    RESTORE                             //
    ret                                 // }
                                        //
/*******************************************************************************
  Effet:  efface le terminal et affiche la grille
  Usage: x19 -- i    x21 -- adr
         x20 -- j    w22 -- case
*******************************************************************************/
afficher:                               // void afficher()
    SAVE                                // {
    adr     x0, effacement              //
    bl      printf                      //   effacer le contenu du terminal
    adr     x0, sautLigne               //
    bl      printf                      //   printf("\n")
                                        //
    adr     x21, grille                 //   adr = &grille
    mov     x19, 0                      //   i   = 0
afficher_boucle_ligne:                  //
    cmp     x19, NUM_LIGNES             //   while (i < NUM_LIGNES)
    b.hs    afficher_fin                //   {
    mov     x20, 0                      //     j = 0
afficher_boucle_col:                    //
    cmp     x20, NUM_COLONNES           //
    b.hs    afficher_prochaine_ligne    //     while (j < NUM_COLONNES)
                                        //     {
    // Afficher case courante           //
    ldrb    w22, [x21], 1               //       case = *adr; adr++
afficher_personne1:                     //
    cmp     w22, 1                      //       if (case == 1)
    b.ne    afficher_personne2          //       {
    adr     x0, jetonUn                 //         symbole = "◉"
    b       afficher_case               //
afficher_personne2:                     //       }
    cmp     w22, 2                      //       else if (case == 2)
    b.ne    afficher_vide               //       {
    adr     x0, jetonDeux               //         symbole = "●"
    b       afficher_case               //       }
afficher_vide:                          //       else
    adr     x0, caseVide                //         symbole = " "
afficher_case:                          //
    bl      printf                      //       printf(symbole)
                                        //
    add     x20, x20, 1                 //       j++
    b       afficher_boucle_col         //     }
                                        //
afficher_prochaine_ligne:               //
    adr     x0, sautLigne               //
    bl      printf                      //     printf("\n")
                                        //
    add     x19, x19, 1                 //     i++
    b       afficher_boucle_ligne       //   }
afficher_fin:                           //
    adr     x0, sautLigne               //
    bl      printf                      //   printf("\n")
    RESTORE                             //
    ret                                 // }
                                        //
/*******************************************************************************
  Entrée: personne ∈ {1, 2}
  Effet:  lit le numéro d'une colonne et ajoute un jeton dans cette colonne
          assigné à «personne»
  Usage: x19 -- personne    x21 -- &grille    w23 -- élément à &grille + index
         x20 -- colonne     x22 -- index
*******************************************************************************/
ajouter_jeton:                          // void ajouter_jeton(personne)
    SAVE                                // {
    mov     x19, x0                     //
                                        //
    // Demande d'entrer une colonne     //
    adr     x0, msgLecture              //
    mov     x1, x19                     //
    bl      printf                      //   printf(msgLecture)
                                        //
    // Lire colonne                     //
    adr     x0, fmtNum                  //
    adr     x1, temp                    //
    bl      scanf                       //   scanf("%lu", &temp)
    ldr     x20, temp                   //
    sub     x20, x20, 1                 //   colonne = temp - 1
                                        //
    // Identifier la position où tombe  //
    //  le jeton dans la colonne        //
    adr     x21, grille                 //
    mov     x22, NUM_LIGNES             //
    sub     x22, x22, 1                 //
    mov     x23, NUM_COLONNES           //   index  = NUM_LIGNES - 1
    mul     x22, x22, x23               //   index *= NUM_COLONNES
    add     x22, x22, x20               //   index += colonne
                                        //
ajouter_jeton_boucle:                   //   while (*(&grille + index) != 0)
    ldrb    w23, [x21, x22]             //   {
    cbz     w23, ajouter_jeton_fin      //
    sub     x22, x22, NUM_COLONNES      //     index -= NUM_COLONNES
    b       ajouter_jeton_boucle        //   }
                                        //
ajouter_jeton_fin:                      //
    strb    w19, [x21, x22]             //   *(&grille + index) = personne
    RESTORE                             //
    ret                                 // }
                                        //
/*******************************************************************************
  Entrée: —
  Sortie: une personne a remporté la partie?
  Usage: x19 -- i    x21 --   NUM_LIGNES - 4
         x20 -- j    x22 -- NUM_COLONNES - 4
*******************************************************************************/
victoire:                               // bool victoire()
    SAVE                                // {
    // Calculer bornes - 4              //
    mov     x21, NUM_LIGNES             //
    sub     x21, x21, 4                 //
    mov     x22, NUM_COLONNES           //
    sub     x22, x22, 4                 //
                                        //
    // Il y a un segment gagnant?       //
    mov     x19, 0                      //   i = 0
victoire_boucle_ligne:                  //
    cmp     x19, NUM_LIGNES             //   while (i != NUM_LIGNES)
    b.eq    victoire_faux               //   {
    mov     x20, 0                      //     j = 0
victoire_boucle_colonne:                //
    cmp     x20, NUM_COLONNES           //     while (j != NUM_COLONNES)
    b.eq    victoire_prochaine_ligne    //     {
                                        //
    // Vérifier segment horizontal      //
victoire_horizontal:                    //
    cmp     x20, x22                    //       if (j <= NUM_COLONNES - 4)
    b.hi    victoire_vertical           //       {
    mov     x0, x19                     //         pos = (i, j)
    mov     x1, x20                     //
    mov     x2, 0                       //         dir = (0, 1)
    mov     x3, 1                       //
    bl      verifier_segment            //         if verifier_segment(pos, dir)
    cbnz    x0, victoire_ret            //           return true
                                        //       }
    // Vérifier segment vertical        //
victoire_vertical:                      //
    cmp     x19, x21                    //       if (i <= NUM_LIGNES - 4)
    b.hi    victoire_diagonal_bas       //        {
    mov     x0, x19                     //         pos = (i, j)
    mov     x1, x20                     //
    mov     x2, 1                       //         dir = (1, 0)
    mov     x3, 0                       //
    bl      verifier_segment            //         if verifier_segment(pos, dir)
    cbnz    x0, victoire_ret            //           return true
                                        //       }
    // Vérifier segment diagonal ⭨      //
victoire_diagonal_bas:                  //
    cmp     x19, x21                    //
    b.hi    victoire_diagonal_haut      //       if (i <= NUM_LIGNES - 4 &&
    cmp     x20, x22                    //           j <= NUM_COLONNES - 4)
    b.hi    victoire_diagonal_haut      //       {
    mov     x0, x19                     //         pos = (i, j)
    mov     x1, x20                     //
    mov     x2, 1                       //         dir = (1, 1)
    mov     x3, 1                       //
    bl      verifier_segment            //         if verifier_segment(pos, dir)
    cbnz    x0, victoire_ret            //           return true
                                        //       }
    // Vérifier segment diagonal ⭧      //
victoire_diagonal_haut:                 //
    cmp     x19, 3                      //
    b.lo    victoire_prochaine_colonne  //       if (i >= 3 &&
    cmp     x20, x22                    //           j <= NUM_COLONNES - 4)
    b.hi    victoire_prochaine_colonne  //       {
    mov     x0, x19                     //         pos = (i, j)
    mov     x1, x20                     //
    mov     x2, -1                      //         dir = (-1, 1)
    mov     x3, 1                       //
    bl      verifier_segment            //         if verifier_segment(pos, dir)
    cbnz    x0, victoire_ret            //           return true
                                        //       }
victoire_prochaine_colonne:             //
    add     x20, x20, 1                 //       j++
    b       victoire_boucle_colonne     //     }
victoire_prochaine_ligne:               //
    add     x19, x19, 1                 //     i++
    b       victoire_boucle_ligne       //   }
victoire_faux:                          //
    mov     x0, 0                       //   return false
victoire_ret:                           //
    RESTORE                             //
    ret                                 // }
                                        //
/*******************************************************************************
  Entrée: pos = (i, j)
          dir = (x, y)
  Sortie: les 4 cases consécutives débutant à pos dans la direction dir,
          sont-elles assignées à une même personne?
  Usage: x19 -- &grille    x21 -- saut             x23 -- i
         x20 -- index      w22 -- premiere_case    w24 -- case
*******************************************************************************/
verifier_segment:                       // bool verifier_segment(i, j, x, y)
    SAVE                                // {
    adr     x19, grille                 //
                                        //
    // Calculer index de grille[i, j]   //
    // et du saut relatif (x, y)        //
    mov     x20, NUM_COLONNES           //
    mul     x20, x0, x20                //
    add     x20, x20, x1                //   index = i * NUM_COLONNES + j
    mov     x21, NUM_COLONNES           //
    mul     x21, x2, x21                //
    add     x21, x21, x3                //   saut  = x * NUM_COLONNES + y
                                        //
    // Valeur retour par défaut = faux  //
    mov     x0, 0                       //
                                        //
    // 1ère case utilisée?              //
    ldrb    w22, [x19, x20]             //   premiere_case = *(&grille + index)
                                        //
    cbz     w22, verifier_segment_ret   //   if (premiere_case == 0)
                                        //     return false
    // 1ère case = 3 cases suivantes?   //
    mov     x23, 3                      //   for (i = 3; i != 0, i--)
verifier_segment_boucle:                //   {
    add     x20, x20, x21               //     index += saut
    ldrb    w24, [x19, x20]             //     case   = *(&grille + index)
                                        //
    cmp     w24, w22                    //     if (case != premiere_case)
    b.ne    verifier_segment_ret        //       return false
                                        //
    sub     x23, x23, 1                 //
    cbnz    x23, verifier_segment_boucle//   }
                                        //
    mov     x0, 1                       //   return true
verifier_segment_ret:                   //
    RESTORE                             //
    ret                                 // }

// Données statiques
.section ".rodata"
caseVide:   .asciz  " ○"
jetonUn:    .asciz  " \x1B[33m◉\033[0m" // Rendre jaune + ◉ + restaurer couleur
jetonDeux:  .asciz  " \x1B[31m●\033[0m" // Rendre rouge + ● + restaurer couleur
effacement: .asciz  "\033[H\033[J"      // Caractères spéciaux pour effacer
sautLigne:  .asciz  "\n"
fmtNum:     .asciz  "%lu"
msgLecture: .asciz  "Personne %lu, entrez le numéro d'une colonne: "
msgSucces:  .asciz  "Victoire de la personne %lu.\n"
msgNulle:   .asciz  "Partie nulle.\n"

.section ".bss"
            .align  8
temp:       .skip   8
grille:     .skip   NUM_ELEM
