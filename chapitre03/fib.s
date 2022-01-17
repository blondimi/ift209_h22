.global main

// Exemple du calcul de la suite de Fibonacci
//      n = 0 1 2 3 4 5 6 7  ...
// fib(n) = 0 1 1 2 3 5 8 13 ...
//
// Entrée: entier non négatif n
// Sortie: n-ème terme de la suite de Fibonacci
// Usage des registres:
//   x19 -- n   x21 -- b
//   x20 -- a   x22 -- c
main:                                   //
        // Lecture de n                 //
        adr     x0, fmtLecture          //
        adr     x1, temp                //
        bl      scanf                   //
        ldr     x19, temp               // n = scanf("%lu", &n)
                                        //
        // Calcul de fib(n)             //
        mov     x20, 0                  // a = 0
        mov     x21, 1                  // b = 1
boucle:                                 //
        cbz     x19, fin_boucle         // while (n != 0) {
        add     x22, x20, x21           //   c = a + b
        mov     x20, x21                //   a = b
        mov     x21, x22                //   b = c
        sub     x19, x19, 1             //   n--
        b       boucle                  // }
fin_boucle:                             //
        // Afficher fib(n)              //
        adr     x0, fmtSortie           //
        mov     x1, x20                 //
        bl      printf                  // printf("%lu\n", a)
                                        //
        // Quitter                      //
        mov     x0, 0                   //
        bl      exit                    //

.section ".rodata"
fmtLecture:     .asciz  "%lu"
fmtSortie:      .asciz  "%lu\n"

.section ".bss"
                .align  8
temp:           .skip   8
