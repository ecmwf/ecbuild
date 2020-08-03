#ifndef A_EXPORT
#error A_EXPORT should be exported by projectA via projectB
#endif

extern int libraryB();

int libraryC() {
  return libraryB();
}

