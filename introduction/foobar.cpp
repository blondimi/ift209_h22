#include <iostream>

void foo()
{
  while (true) {
    std::cout << "foo" << std::endl;
  }
}

void bar()
{
  std::cout << "bar()" << std::endl;

  bar();
}

int main()
{
  foo();
  bar();
}
