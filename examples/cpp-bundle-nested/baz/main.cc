#include <iostream>

extern "C" {
#include "foo.h"
#include "baz.h"
}

int main()
{
  std::cout << "foo is " << foo() << std::endl;
  std::cout << "baz is " << baz() << std::endl;
}
