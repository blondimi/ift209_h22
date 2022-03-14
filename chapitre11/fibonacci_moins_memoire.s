fib:                                 // fib(n)
        // Sauvegarder environnement // {
        stp     x29, x30, [sp, -32]! //
        mov     x29, sp              //
        stp     x19, x20, [sp, 16]   //
                                     //
        // Calculer fib(n)           //
        mov     x19, x0              //
        cmp     x19, 2               //   if (n >= 2)
        b.lo    fin                  //   {
                                     //
        sub     x0, x19, 1           //
        bl      fib                  //
        mov     x20, x0              //     r = fib(n - 1)
                                     //
        sub     x0, x19, 2           //
        bl      fib                  //
        add     x0, x20, x0          //     n = r + fib(n - 2)
fin:                                 //   }
        // Restaurer environnement   //
        ldp     x29, x30, [sp], 16   //
        ldp     x19, x20, [sp], 16   //
        ret                          //   return n
                                     // }
