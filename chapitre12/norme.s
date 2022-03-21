.global main

/*******************************************************************************
  Calcule la norme euclidienne d'un vecteur (x, y)
*******************************************************************************/
main:                      // main()
    // Lire x              // {
    adr     x0, fmtEntree  //
    adr     x1, temp       //
    bl      scanf          //   scanf("%lf", &temp)
    ldr     d8, temp       //   x = temp
                           //
    // Lire y              //
    adr     x0, fmtEntree  //
    adr     x1, temp       //
    bl      scanf          //
    ldr     d9, temp       //   scanf("%lf", &temp)
                           //   y = temp
    // Calculer ||(x, y)|| //
    fmov    d0, d8         //
    fmov    d1, d9         //
    bl      norme          //
    fmov    d8, d0         //   n = norme(x, y)
                           //
    // Afficher ||(x, y)|| //
    adr     x0, fmtSortie  //
    fmov    d0, d8         //
    bl      printf         //   printf("%lf\n", n)
                           //
    // Quitter             //
    mov     x0, 0          //
    bl      exit           //   return 0
                           // }
/*******************************************************************************
  Entrée: nombres x, y en virgule flottante précision double
  Sortie: norme euclidienne du vecteur (x, y)
*******************************************************************************/
norme:                     // double norme(double x, double y) {
    fmul    d16, d0, d0    //
    fmul    d17, d1, d1    //
    fadd    d18, d16, d17  //
    fsqrt   d0, d18        //
    ret                    //   return √(x² + y²)
                           // }

.section ".rodata"
fmtEntree:  .asciz  "%lf"
fmtSortie:  .asciz  "%lf\n"

.section ".bss"
            .align  8
temp:       .skip   8
