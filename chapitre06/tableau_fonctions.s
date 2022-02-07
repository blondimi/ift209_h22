.global main

// Exemple de l'utilisation d'un tableau de pointeurs de fonctions
//
// Entrée: lit un entier non négatif i
// Sortie: affiche tab[i](7, 5) où tab = {somme, produit, différence}
// Usage des registres:
//   x19 -- adresse de tab          x27 -- 7 (figé dans le code)
//   x20 -- valeur temporaire       x28 -- 5 (figé dans le code)
//   x21 -- i
//   x22 -- index de tab
main:                                   // main()
    // Initialiser tab                  // {
    adr     x19, tab                    //
    adr     x20, somme                  //
    str     x20, [x19], 8               //
    adr     x20, produit                //
    str     x20, [x19], 8               //
    adr     x20, diff                   //
    str     x20, [x19]                  //   tab = {&somme, &produit, &diff}
                                        //
    // Lire chiffre                     //
    adr     x0, fmtEntree               //
    adr     x1, temp                    //
    bl      scanf                       //   scanf("%u", &temp)
    ldr     x21, temp                   //   i = temp
                                        //
    // Évaluer f(7, 5) où f := tab[i]   //
    mov     x20, 8                      //
    mul     x22, x20, x21               //
    adr     x19, tab                    //
    ldr     x20, [x19, x22]             //   f = tab[i]  (où index = &tab + 8*i)
    mov     x27, 7                      //   x = 7
    mov     x28, 5                      //   y = 5
    br      x20                         //   f(x, y)
                                        //
somme:                                  //   somme(x, y) {
    add     x1, x27, x28                //     z = x + y
    b       afficher                    //   }
produit:                                //   produit(x, y) {
    mul     x1, x27, x28                //     z = x * y
    b       afficher                    //   }
diff:                                   //   diff(x, y) {
    sub     x1, x27, x28                //     z = x - y
    b       afficher                    //   }
                                        //
    // Afficher résultat                //
afficher:                               //
    adr     x0, fmtSortie               //
    bl      printf                      //   printf("%lu\n", z)
                                        //
    mov     x0, 0                       //
    bl      exit                        // }
                                        //
.section ".bss"                         //
tab:    .skip   3*8                     // tab[] = tableau de 3 double mots
temp:   .skip   4                       // temp  = variable d'un mot
                                        //
.section ".rodata"                      //
fmtEntree:  .asciz  "%u"                //
fmtSortie:  .asciz  "%lu\n"             //
