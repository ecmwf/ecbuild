#include <iostream>

extern "C" {
#include "bar.h"
}

int main()
{
  std::cout << "bar is " << bar() << std::endl;
}
