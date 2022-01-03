#include <iostream>

unsigned long foo(unsigned long n)
{
  unsigned long t = 0;

  while (n > 0) {
    t += n;
    n -= 1;
  }

  return t;
}

int main()
{
  std::cout << foo(4) << std::endl;
}
