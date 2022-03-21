#include <algorithm>
#include <iomanip>
#include <iostream>
#include <numeric>
#include <vector>

// Exemple de somme dont l'ordre des additions modifie le résultat
int main()
{
  std::vector<double> t = {100000000000000.0,
                           0.1,
                           0.0000000000001,
                           1000000000000000000.0,
                           0.0000000001,
                           1000000.0,
                           1000000000.0};

  double x = std::accumulate(t.begin(), t.end(), 0.0); // x = somme(t)

  std::sort(t.begin(), t.end());                       // trier t

  double y = std::accumulate(t.begin(), t.end(), 0.0); // y = somme(t)
  
  std::cout << std::setprecision(53)
            << "Somme du vecteur non trié x = " << x << std::endl
            << "Somme du vecteur trié     y = " << y << std::endl
            << "x == y? " << (x == y ? "Oui!" : "Non...")
            << std::endl;
}
