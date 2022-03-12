echange:             // echange(a, b)
    eor x0, x0, x1   // {
    eor x1, x0, x1   //
    eor x0, x0, x1   //   return (b, a)
    ret              // }
