#include <stdio.h>

int main()
{
  unsigned long x;

  printf("Entrez un nombre: ");
  scanf("%lu", &x);

  // Cette boucle se termine
  while (x > 0) {
    printf("%lu\n", x);
    x--;
  }

  printf("Entrez un nombre: ");
  scanf("%lu", &x);

  // Cette boucle ne termine jamais
  while (x >= 0) {
    printf("%lu\n", x);
    x--;
  }
}
