#ifdef A_PRIVATE
#error A_PRIVATE should not be exported by target projectA_private
#endif
#ifdef A_PUBLIC
#error A_PUBLIC should not be exported by target projectA
#endif
#ifndef A_EXPORT
#error A_EXPORT should have been exported by target projectA
#endif

#include "libraryB.h"

extern int libraryA();

int libraryB() {
  return libraryA();
}

