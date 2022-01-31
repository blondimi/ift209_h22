#include <iostream>

int main()
{
  unsigned long x;

  std::cout << "Entrez un nombre: ";
  std::cin  >> x;

  // Cette boucle se termine
  while (x > 0) {
    std::cout << x << std::endl;
    x--;
  }

  std::cout << "Entrez un nombre: ";
  std::cin  >> x;

  // Cette boucle ne termine jamais
  while (x >= 0) {
    std::cout << x << std::endl;
    x--;
  }
}
