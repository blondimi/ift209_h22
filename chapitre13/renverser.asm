dir:      .rs 1 ; vaut 0 (gauche) ou 1 (droite)
tuile:    .rs 4 ; (posY, identifiant, attributs, posX)

renverser:                       ; renverser()
    ldx   #2                     ; {
    lda   dir                    ;
    cmp   #0                     ;
    bne   renverser_un           ;   if (dir == 0)
renverser_zero:                  ;   {
    lda   tuile, x               ;
    and   #%10111111             ;     a = tuile[2] & 0xBF
    jmp   renverser_fin          ;   }
renverser_un:                    ;   else
    lda   tuile, x               ;   {
    ora   #%01000000             ;     a = tuile[2] | 0x40
renverser_fin:                   ;   }
    sta   tuile, x               ;   tuile[2] = a
    rts                          ; }
