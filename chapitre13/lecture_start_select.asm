appuye:    .rs 1

lecture:                         ; lecture()
    ; Demander lecture boutons   ; {
    lda    #1                    ;   envoyer 1
    sta    $4016                 ;     au port de manette 1
    lda    #0                    ;   envoyer 0
    sta    $4016                 ;     au port de manette 1
                                 ;
    ; Déterminer si SELECT       ;
    ;     et START sont appuyés  ;
    lda    $4016                 ;   lire et ignorer A
    lda    $4016                 ;   lire et ignorer B
                                 ;
    lda    $4016                 ;
    and    #%00000001            ;   lire état x de SELECT
    sta    appuye                ;   appuye = x
                                 ;
    lda    $4016                 ;
    and    #%00000001            ;   lire état y de START
    and    appuye                ;
    sta    appuye                ;   appuye &= y
                                 ;
    rts                          ; }
