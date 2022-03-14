fib:                                // fib(n)
        SAVE                        // {
        mov     x19, x0             //
        cmp     x19, 2              //   if (n >= 2)
        b.lo    fin                 //   {
                                    //
        sub     x0, x19, 1          //
        bl      fib                 //
        mov     x20, x0             //     r = fib(n - 1)
                                    //
        sub     x0, x19, 2          //
        bl      fib                 //
        add     x0, x20, x0         //     n = r + fib(n - 2)
fin:                                //   }
        RESTORE                     //
        ret                         //   return n
                                    // }
