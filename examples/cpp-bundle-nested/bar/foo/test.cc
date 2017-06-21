#include <iostream>

extern "C" {
#include "foo.h"
}

int main() {
  if( foo() == 42)
    std::cout << "ok" << std::endl;
  else
    std::cout << "failed" << std::endl;
}
