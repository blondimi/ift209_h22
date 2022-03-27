.global main

/*******************************************************************************
  Exemple d'entrées/sorties par appels système
*******************************************************************************/
main:                       // main()
    adr     x0, temp        // {
    mov     x1, 10          //
    bl      lire            //   lire(&temp, 10)
                            //
    adr     x0, temp        //
    mov     x1, 10          //
    bl      afficher        //   afficher(&temp, 10)
                            //
    mov     x0, 0           //
    bl      exit            //   return 0
                            // }
/*******************************************************************************
 Entrée: adresse d'une chaîne de caractère et sa taille
 Effet:  affiche la chaîne sur le flux standard de sortie
*******************************************************************************/
afficher:                   // afficher(chaine, taille)
    mov     x9, x0          // {
    mov     x10, x1         //
                            //
    mov     x8, 64          //   /* write  = 64
    mov     x0, 1           //      stdout = 1  */
    mov     x1, x9          //
    mov     x2, x10         //
    svc     0               //   write(stdout, chaine, taille)
                            //
    ret                     // }
/*******************************************************************************
 Entrée: adresse d'une mémoire tampon et une taille
 Effet:  lit une chaîne de la taille spécifiée à partir du flux standard
         d'entrée, et la stocke dans la mémoire tampon
*******************************************************************************/
lire:                       // lire(tampon, taille)
    mov     x9, x0          // {
    mov     x10, x1         //
                            //
    mov     x8, 63          //   /* read   = 63
    mov     x0, 0           //      stdin  = 0  */
    mov     x1, x9          //
    mov     x2, x10         //
    svc     0               //   read(stdin, tampon, taille)
                            //
    ret                     // }

.section ".bss"
temp:       .skip   10
