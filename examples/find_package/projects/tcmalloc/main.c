#include <stdlib.h>
#include <stdio.h>
int main() {
  int length = 32;
  double* array = (double*) malloc( sizeof(double) * length );
  for( int i=0; i<length; ++ i ) { array[i] = 1.; }
  printf( "%f\n", array[0] );
  free(array);
}
