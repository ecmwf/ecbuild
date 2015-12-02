#include "stdio.h"
#include "math.h"

double area_circle_(double *);

int main() {

  double r = 10.;
  double a = area_circle_(&r);

  printf("%le %le %le\n", r, a, fabs(a - 100*M_PI));

  if( fabs(a - 100*M_PI) > 1E-5 )
    return -1;
  else
    return 0;
}

