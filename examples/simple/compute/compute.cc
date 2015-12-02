#include <iostream>

#ifdef HAVE_GSL
#include <gsl/gsl_sf_bessel.h>
#endif

using namespace std;

extern "C"
{
  double area_circle_(double *);
}

int main() {

  double x = 12.;
  std::cout << "x = "  << x << std::endl;

  double a = area_circle_(&x);

  std::cout << "area_circle = " << a << std::endl;

#ifdef HAVE_GSL
  double b = gsl_sf_bessel_J0(x);
  std::cout << "Bessel J0 = " << b << std::endl;
#endif

  return 0;
}

