.include "macros_save_restore.s"
.global  main

/*******************************************************************************
  Exemple de sous-programme: maximum de deux entiers
*******************************************************************************/
main:                               // main()
        mov      x0, 42             // {
        mov      x1, 9000           //
        bl       max                //
        mov      x19, x0            //   m = max(42, 9000)
                                    //
        adr      x0, fmtSortie      //
        mov      x1, x19            //
        bl       printf             //   printf("%ld\n", m)
                                    //
        mov      x0, 0              //
        bl       exit               //   return 0
                                    // }
/*******************************************************************************
  Entrée: entiers signés a et b de 64 bits
  Sortie: max(a, b)
  Usage:  x19 -- m
*******************************************************************************/
max:                                // long max(long a, long b)
        SAVE                        // {
        cmp      x0, x1             //
        b.lt     max_sinon          //   if (a >= b) {
        mov      x19, x0            //     m = a
        b        max_retour         //   }
max_sinon:                          //   else {
        mov      x19, x1            //     m = b
max_retour:                         //   }
        mov      x0, x19            //
        RESTORE                     //
        ret                         //   return m
                                    // }

.section ".rodata"
fmtSortie:      .asciz  "%ld\n"
