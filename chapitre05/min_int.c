#include <limits.h>
#include <stdio.h>

// Exemple de division qui ne donne pas le résultat attendu
int main()
{
  int x = INT_MIN;
  int y = x / -1;

  printf("%d ≠ %d?\n", x, y);
}
