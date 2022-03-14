.include "macros.s"                 // "
.global main

/*******************************************************************************
  Lit une chaîne et indique si son premier caractère fait partie du codage ASCII
*******************************************************************************/
main:                               // main()
    // Lire chaîne                  //
    adr     x0, fmtLecture          // {
    adr     x1, chaine              //
    bl      scanf                   //   scanf(&fmtLecture, &chaine)
                                    //
    // Déterminer si ASCII          //
    adr     x0, chaine              //
    bl      est_ascii               //
    mov     x19, x0                 //   ascii = est_ascii(chaine)
                                    //
    // Afficher si ASCII            //
    cbz     x19, main_pas_ascii     //
main_est_ascii:                     //   if (ascii) {
    adr     x0, msgVrai             //     msg = &msgVrai
    b       main_afficher_ascii     //   }
main_pas_ascii:                     //   else {
    adr     x0, msgFaux             //     msg = &msgFaux
main_afficher_ascii:                //   }
    bl      printf                  //   printf(msg)
                                    //
    // Terminer le programme        //
    mov     x0, 0                   //
    bl      exit                    //   return 0
                                    // }
/*******************************************************************************
  Entrée: adresse d'une chaîne de caractères
  Sortie: 1 si son première caractère fait partie du codage ASCII, 0 sinon
  Usage:  w19 - c (premier caractère de la chaîne)
*******************************************************************************/
est_ascii:                          // est_ascii(chaine)
    SAVE                            // {
    ldrb    w19, [x0]               //   c = chaine[0]
                                    //
    // Basculer le bit 7 de c       //
    //          et retourner ce bit //
    eor     w19, w19, 0x80          //   c = c ⊕ 10000000₂
    lsr     w0, w19, 7              //   c = c >> 7
    RESTORE                         //
    ret                             //   return c
                                    // }

// Données statiques
.section ".data"
chaine:     .skip 1024

.section ".rodata"
msgVrai:    .asciz  "Le premiere caractère est sous codage ASCII.\n"
msgFaux:    .asciz  "Le premiere caractère n'est pas sous codage ASCII.\n"
fmtLecture: .asciz  "%[^\n]s"       // Format pour lire une chaîne de caractères
                                    // d'une ligne (incluant des espaces)
