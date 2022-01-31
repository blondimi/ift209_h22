#include <iostream>
#include <limits>

// Exemple de division qui ne donne pas le résultat attendu
int main()
{
  int x = std::numeric_limits<int>::min();
  int y = x / -1;

  std::cout << x << " ≠ " << y << "?" << std::endl;
}
