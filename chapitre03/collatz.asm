;; Adaptation de collatz.s pour x86-64 (sous syntaxe Intel plutôt que AT&T)
;;
;; Pour assembler et exécuter sur Ubuntu:
;;
;; nasm -f elf64 collatz.asm && gcc -no-pie -o collatz collatz.o && ./collatz
;;
global  main
extern  exit, printf, scanf

main:
        ; Lecture de n
        mov	rdi, fmtEntree  ;
        mov	rsi, temp       ;
        mov     rax, 0          ;
        sub	rsp, 8          ; aligner la pile
        call    scanf           ; scanf(adr(fmtEntree), adr(temp))
        add	rsp, 8          ;
        mov	r12, [temp]     ; n ← temp

        ; Calcul du temps de vol
        mov	r13, 0          ; t ← 0
boucle:
        cmp	r12, 1          ;
        je	finboucle       ; si n = 1: aller à finboucle
        inc	r13             ; t ← t + 1

        ; Calcul de f(n)
        test	r12, 1          ;
        jnz	impair          ; si n est impair: aller à impair
pair:
        mov	rdx, 0          ;
        mov	rax, r12        ; a ← n
        mov	r14, 2          ; d ← 2
        div	r14             ; a ← a ÷ d
        mov	r12, rax        ; n ← a        
        jmp	fin             ; aller à fin
impair:
        mov	rax, 3          ; a ← 3
        mul	r12             ; a ← a * n
        inc	rax             ; a ← a + 1
        mov	r12, rax        ; n ← a
fin:

        jmp	boucle          ; aller à boucle
finboucle:
        
        ; Affichage du temps de vol
        mov     rdi, msgRes     ;
        mov     rsi, r13        ;
        mov     rax, 0          ;
        call    printf          ; printf(adr(msgRes), t)

        mov	rdi, 0          ;
        call	exit            ; Quitter le programme

section .bss
temp:
        align   8
        resq	1

section .data
fmtEntree:
        db	"%lu", 0
msgRes:
        db	"Résultat: %lu", 0
