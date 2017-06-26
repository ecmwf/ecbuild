#include <iostream>

extern "C" {
#include "foo.h"
#include "bar.h"
}

int main()
{
  std::cout << "foo is " << foo() << std::endl;
  std::cout << "bar is " << bar() << std::endl;
}
