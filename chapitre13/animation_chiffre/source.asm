;; Macros pour l'émulateur ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    .inesprg 1
    .ineschr 1
    .inesmir 0
    .inesmap 0

;; Variables (allouées dans la mémoire principale à partir de 0x0000) ;;;;;;;;;;
    .rsset  $0000               ;
posX:       .rs 1               ; Position horizontale du chiffre     (1 octet)
posY:       .rs 1               ; Position verticale du chiffre       (1 octet)
chiffre:    .rs 1               ; Tuile du chiffre entre 1 et 10      (1 octet)
iter:       .rs 1               ; Nombre d'itérations à effectuer     (1 octet)
                                ;
;; Segment de code du jeu ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    .bank   0                   ;
    .org    $C000               ; Adresse du segment de code du jeu
                                ;
; Point d'entrée (appelé lors d'une interruption RESET)
main:                           ; main() {
    sei                         ;   Désactiver les interruptions IRQ
    cld                         ;   Désactiver le mode décimal (non supporté)
    lda     #%00000000          ;   Désactiver temporairement les interruptions
    sta     $2000               ;
                                ;
    ldx     #$FF                ;
    txs                         ;   Initialiser la pile d'exécution: s = 0xFF
                                ;
    jsr     init_variables      ;   Initialiser les variables
    jsr     init_palette        ;   Initialiser les palettes de couleur
                                ;
    lda     #%10011000          ;   Réactiver les interruptions et
    sta     $2000               ;               choisir les tables de tuiles
    lda     #%00010000          ;
    sta     $2001               ;   Activer les tuiles
                                ;
boucle:                         ;   Boucle infinie
    jmp     boucle              ; }
                                ;
; Sous-routine de mise à jour: appelée par interruption à chaque
; rafraîchissement vertical de l'affichage
update:                         ; update()
    lda     #$02                ; {
    sta     $4014               ;   Copier tuiles 0x0200 à 0x02FF vers PPU
                                ;
    jsr     deplacer_chiffre    ;   deplacer_chiffre()
    jsr     update_chiffre      ;   update_chiffre()
                                ;
    rti                         ; }
                                ;
init_variables:                 ; init_variables()
    lda     #0                  ; {
    sta     posX                ;   posX = 0
    lda     #100                ;
    sta     posY                ;   posY = 100
    lda     #1                  ;
    sta     chiffre             ;   chiffre = 1 (tuile du chiffre 0)
    lda     #24                 ;
    sta     iter                ;   iter = 24
    rts                         ; }
                                ;
deplacer_chiffre:               ; deplacer_chiffre() {
    inc     posX                ;   posX++
                                ;
    lda     #1                  ;
    sta     $4016               ;
    lda     #0                  ;
    sta     $4016               ;   Demander une lecture des boutons
                                ;
    lda     $4016               ;
    and     #%00000001          ;   Lire bit b de poids faible du bouton A
                                ;
    clc                         ;
    adc     posY                ;
    sta     posY                ;   posY += b       ; posY++ ssi A est enfoncé
                                ;
    rts                         ; }
                                ;
update_chiffre:                 ; update_chiffre()
    ; Position verticale        ; {
    lda     posY                ;
    sta     $0200               ;   mem[0x0200] = posY
                                ;
    ; Choix de la tuile         ;
    lda     chiffre             ;   mem[0x0201] = chiffre
    sta     $0201               ;
                                ;
    lda     iter                ;
    cmp     #0                  ;   if (iter != 0) {
    beq     prochain_chiffre    ;
prochaine_iteration:            ;
    sec                         ;
    dec     iter                ;     iter--
    jmp     continuer           ;   }
prochain_chiffre:               ;   else {
    lda     #24                 ;
    sta     iter                ;     iter = 24
    inc     chiffre             ;     chiffre++
    lda     chiffre             ;
    cmp     #11                 ;
    bne     continuer           ;     if (chiffre == 11) {
    lda     #1                  ;
    sta     chiffre             ;       chiffre = 1
                                ;     }
continuer:                      ;   }
    ; Attributs de la tuile     ;
    lda     #%00000000          ;
    sta     $0202               ;   mem[0x0202] = 0
                                ;
    ; Position horizontale      ;
    lda     posX                ;
    sta     $0203               ;   mem[0x0203] = posX
                                ;
    rts                         ; }
                                ;
; Sous-routine qui initialise les palettes de couleurs
init_palette:                   ; init_palette()
    lda     #$3F                ; {
    sta     $2006               ;
    lda     #$10                ;
    sta     $2006               ;   i = 0x3F00 (palettes de couleur)
    ldx     #0                  ;   x = 0
                                ;
init_palette_boucle:            ;   do {
    lda     palettes, x         ;
    sta     $2007               ;     mem_video[i] = palettes[x]
                                ;     i++           ; auto-incrémenté par le PPU
    inx                         ;     x++
    cpx     #16                 ;   }
    bne     init_palette_boucle ;   while (x < 16)
                                ;
    rts                         ; }
                                ;
                                ;
;; Segment de données statiques ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Palettes de couleur           ;
palettes:                       ;
    .byte   $10, $16, $27, $18  ; Palette de couleur des tuiles
    .byte   $10, $0F, $0F, $0F	;
    .byte   $10, $0F, $0F, $0F	;
    .byte   $10, $0F, $0F, $0F	;
                                ;
;; Segment des interruptions ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    .bank    1                  ;
    .org     $FFFA              ; Adresse du vecteur d'interruptions
    .word    update             ; Appelé lors d'une interruption NMI (VBlank)
    .word    main               ; Appelé lors d'une interruption RESET
    .word    0                  ; Appelé lors d'une interruption IRQ (désactivé)
                                ;
;; Segment des tuiles ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    .bank    2
    .org     $0000
    .incbin  "tuiles.chr"
