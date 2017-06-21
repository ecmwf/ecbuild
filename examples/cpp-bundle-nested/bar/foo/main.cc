#include <iostream>

extern "C" {
#include "foo.h"
}

int main() {
  std::cout << "foo is " << foo() << std::endl;
}
