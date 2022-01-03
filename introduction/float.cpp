#include <iostream>

int main()
{
  float x = 0.0;

  unsigned int i = 0;

  while (x != 1.0) {
    x += 0.1;
    i += 1;

    std::cout << i << std::endl;
  }
}
