#include "foo/foo.h"

#include <iostream>

int main() {
  std::cout << foo::true_random_int() << std::endl;
  return 0;
}
