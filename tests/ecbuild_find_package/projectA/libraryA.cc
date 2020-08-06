#include "libraryA.h"

#ifdef A_PRIVATE
#error A_PRIVATE should not be exported by target projectA_private
#endif
#ifndef A_PUBLIC
#error A_PUBLIC should have been exported by target projectA_private
#endif
#ifndef A_EXPORT
#error A_EXPORT should be defined
#endif

extern int libraryA_Private();

int libraryA() {
  return libraryA_Private();
}

