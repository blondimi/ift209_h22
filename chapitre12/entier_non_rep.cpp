#include <cmath>
#include <iomanip>
#include <iostream>

unsigned long exp(unsigned int n);

// Exemple d'entier qui n'est pas représentable exactement en virgule flottante
int main()
{
  double x = std::pow(2, 53); // 2⁵³ calculé en nombre à virg. flottante
  unsigned long y = exp(53u); // 2⁵³ calculé directement sur les entiers

  double        xpp = x + 1;
  unsigned long ypp = y + 1;
  
  std::cout << std::setprecision(53)
            << "2⁵³     (double) = " << x   << std::endl
            << "2⁵³     (uint64) = " << y   << std::endl
            << "2⁵³ + 1 (double) = " << xpp << std::endl
            << "2⁵³ + 1 (uint64) = " << ypp << std::endl;
}

// Algorithme d'exponentiation rapide sur les naturels
unsigned long exp(unsigned int n)
{
  if (n == 0) {
    return 1;
  }
  else {
    unsigned long r = exp(n / 2); 

    return (n % 2 == 0) ? (r * r) : (r * r * 2);
  }
}
