.include "macros_save_restore.s"
.global  main

/*******************************************************************************
  Exemples de fonctions qui renverse et affiche le contenu d'un tableau
*******************************************************************************/
main:                           // int main()
    // Exemple 1                // {
    adr     x0, exemple1        //
    mov     x1, 5               //
    bl      renverser           //   renverser(&exemple1, 5)
                                //
    adr     x0, exemple1        //
    mov     x1, 5               //
    bl      afficher            //   afficher(&exemple1, 5)
                                //
    // Exemple 2                //
    adr     x0, exemple2        //
    mov     x1, 6               //
    bl      renverser           //   renverser(&exemple2, 6)
                                //
    adr     x0, exemple2        //
    mov     x1, 6               //
    bl      afficher            //   afficher(&exemple2, 6)
                                //
    mov     x0, 0               //
    bl      exit                //   return 0
                                // }
/*******************************************************************************
  Entrée: - adresse d'un tableau d'entiers de 64 bits
          - nombre d'éléments du tableau
  Effet:  renverse le contenu du tableau en mémoire
  Usage: x19 -- gauche    x21 -- x
         x20 -- droite    x22 -- y
*******************************************************************************/
renverser:                      // void renverser(long tab[], unsigned long taille)
    SAVE                        // {
    mov     x19, x0             //   long* gauche = tab
    mov     x20, 8              //
    mul     x20, x20, x1        //
    sub     x20, x20, 8         //
    add     x20, x19, x20       //   long* droite = tab + taille - 1
renverser_boucle:               //
    cmp     x19, x20            //   while (gauche < droite)
    b.hs    renverser_fin       //   {
    ldr     x21, [x19]          //     long x = *gauche
    ldr     x22, [x20]          //     long y = *droite
                                //
    str     x22, [x19], 8       //     *gauche = y; gauche++
    str     x21, [x20], -8      //     *droite = x; droite--
    b       renverser_boucle    //   }
renverser_fin:                  //
    RESTORE                     //
    ret                         // }
                                //
/*******************************************************************************
  Entrée: - adresse d'un tableau d'entiers de 64 bits
          - nombre d'éléments du tableau
  Effet:  afficher le contenu du tableau
  Usage: x19 -- elem
         x20 -- taille
*******************************************************************************/
afficher:                       // void afficher(long tab[], unsigned long taille)
    SAVE                        // {
    mov     x19, x0             //   long* elem = tab
    mov     x20, x1             //
afficher_boucle:                //
    cbz     x20, afficher_fin   //   while (taille != 0)
    // Afficher élém. courant   //   {
    adr     x0, fmtNum          //
    ldr     x1, [x19]           //
    bl      printf              //     printf("%ld ", *elem)
                                //
    add     x19, x19, 8         //     elem++
    sub     x20, x20, 1         //     taille--
    b       afficher_boucle     //   }
afficher_fin:                   //
    adr     x0, fmtSaut         //
    bl      printf              //   printf("\n")
    RESTORE                     //
    ret                         // }

// Données statiques
.section ".data"
exemple1:   .xword  10, 20, 30, 40, 50
exemple2:   .xword  10, 20, 30, 40, 50, 60

.section ".rodata"
fmtNum:     .asciz  "%ld "
fmtSaut:    .asciz  "\n"
