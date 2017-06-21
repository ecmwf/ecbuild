#include <iostream>

extern "C" {
#include "baz.h"
}

int main() {
  if( baz() == 42*42*42 )
    std::cout << "ok" << std::endl;
  else
    std::cout << "failed" << std::endl;
}
