#include <stdio.h>

int main()
{
  char x[] = "foo";
  char y[] = "bar";
  char z[] = "bonjour";

  for (size_t i = 0; i < sizeof(z); i++) {
    x[i] = z[i];
  }

  printf("%s\n", x);
  printf("%s\n", y);
  printf("%s\n", z);
}
