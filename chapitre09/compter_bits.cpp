#include <iostream>

// Algorithme qui vérifie chaque bit
// Complexité: O(n) où n est le nombre de bits
unsigned int algo1(unsigned long x) {
  unsigned long n = 0;
  
  for (unsigned int i = 0; i < 64; i++) {
    n += x & 1;  // incrémenter selon le dernier bit de x
    x  = x >> 1; // décaler x d'un bit vers la droite
  }

  return n;
}

// Algorithme qui retire un '1' à chaque itération
// Complexité: O(k) où k est le nombre de bits de x égaux à '1'
unsigned int algo2(unsigned long x) {
  unsigned long n = 0;
  
  while (x != 0) {
    x = x & (x - 1);
    n++;
  }

  return n;
}

// But: afficher le nombre de bits égaux à 1 dans x
// Par ex. si x = 13 = 0...0001101, alors afficher 3
int main()
{
  unsigned long x;
  std::cin >> x;

  std::cout << algo1(x) << std::endl
            << algo2(x) << std::endl;
}
