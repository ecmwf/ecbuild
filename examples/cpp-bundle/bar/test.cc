#include <iostream>

extern "C" {
#include "bar.h"
#include "zingo.h"
}

int main()
{
  if( bar() == 42*42 )
    std::cout << "ok" << std::endl;
  else
    std::cout << "failed" << std::endl;

  if( zingo() == 41*42 )
    std::cout << "ok" << std::endl;
  else
    std::cout << "failed" << std::endl;
}