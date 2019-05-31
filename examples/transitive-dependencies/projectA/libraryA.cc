#include "libraryA.h"

extern int libraryA_Private();

int libraryA() {
  return libraryA_Private();
}

