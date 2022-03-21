#include <iostream>
#include <iomanip>

// Problème lors de l'addition d'un très grand et très petit nombre,
// malgré le fait qu'ils soient tous deux représentables exactement
int main()
{
  double x = 1099511627776.0; // 2⁴⁰
  double y = 0.0001220703125; // 2⁻¹³
  double z = x + y;
  
  std::cout << std::setprecision(53)
            << "x = " << x << std::endl
            << "y = " << y << std::endl
            << "    y ≠ 0: " << (y != 0 ? "OK" : "!?") << std::endl
            << "x + y ≠ x: " << (z != x ? "OK" : "!?") << std::endl;
}
