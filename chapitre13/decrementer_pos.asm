posX:     .rs 1

avancer:                         ; avancer()
    ; Demander lecture boutons   ; {
    lda    #1                    ;   envoyer 1
    sta    $4016                 ;     au port de manette 1
    lda    #0                    ;   envoyer 0
    sta    $4016                 ;     au port de manette 1
                                 ;
    ; Ignorer six 1er boutons    ;
    ldx    #0                    ;   x = 0
                                 ;
avancer_lire:                    ;   do {
    lda    $4016                 ;     lire/ignorer bouton
    inx                          ;     x++
    cpx    #6                    ;   }
    bne    avancer_lire          ;   while (x != 6)
                                 ;
    ; Déplacer selon flèche      ;
    lda    $4016                 ;
    and    #%00000001            ;   a = bit d'état de <--
    cmp    #0                    ;
    beq    avancer_fin           ;   if (a != 0)
    dec    posX                  ;     posX--
avancer_fin:                     ;
    rts                          ; }
