#include <stdio.h>

// Exemple de comportement lorsqu'on compare nombres signés et non signés
int main()
{  
  int x = -1;         // x = 1111...1111
  unsigned int y = 1; // y = 0000...0001
  
  if (x < y) {
    printf(":)\n");
  }
  else {
    printf(":(\n");
  }
}
