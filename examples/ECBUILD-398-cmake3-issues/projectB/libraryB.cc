#include "libraryB.h"

extern int libraryA();

int libraryB() {
  return libraryA();
}

