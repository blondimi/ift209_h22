dir:      .rs 1 ; vaut 0 (gauche) ou 1 (droite)
tuile:    .rs 4 ; (posY, identifiant, attributs, posX)

renverser:                       ; renverser()
    ; Créer masque (dir <<= 6)   ; {
    ldx   0                      ;   x = 0
renverser_decal_gauche:          ;   do {
    asl   dir                    ;     dir <<= 1
    inx                          ;     x++
    cpx   #6                     ;   }
    bne   renverser_decal_gauche ;   while (x != 6)
                                 ;
    ; Renverser tuile selon dir  ;
    ldx   #2                     ;
    lda   tuile, x               ;   a  = tuile[2]
    and   #%10111111             ;   a &= 0xBF
    ora   dir                    ;   a |= dir
    sta   tuile, x               ;   tuile[2] = a
                                 ;
    ; Restaurer dir (dir >>= 6)  ;
    ldx   0                      ;   x = 0
renverser_decal_droite:          ;   do {
    lsr   dir                    ;     dir >>= 1
    inx                          ;     x++
    cpx   #6                     ;   }
    bne   renverser_decal_droite ;   while (x != 6)
                                 ;
    rts                          ; }
