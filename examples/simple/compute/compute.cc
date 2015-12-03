#include <iostream>
#include <vector>

#ifdef HAVE_GSL
#include <gsl/gsl_sf_bessel.h>
#endif

using namespace std;

extern "C"
{
  double area_circle_(double *);

  void dgetrf_( int* m, int* n, double* a, int* lda, int* ipiv, int *info );
  void dgetrs_( char* trans, int* n, int* nrhs, const double* a, int* lda, const int* ipiv,double* b, int* ldb, int *info );
}

int main() {

  double x = 12.;
  std::cout << "x = "  << x << std::endl;

  double ca = area_circle_(&x);

  std::cout << "area_circle = " << ca << std::endl;

#ifdef HAVE_GSL
  double cb = gsl_sf_bessel_J0(x);
  std::cout << "Bessel J0 = " << cb << std::endl;
#endif


#ifdef HAVE_MATRIX_LAPACK

    char    TRANS = 'N';
    int     INFO=3;
    int     LDA = 3;
    int     LDB = 3;
    int     N = 3;
    int     NRHS = 1;
    int     IPIV[3] ;

    double  A[9] =
    {
    1, 2, 3,
    2, 3, 4,
    3, 4, 1
    };

    double B[3] =
    {
    -4,
    -1,
    -2
    };

    dgetrf_(&N,&N,A,&LDA,IPIV,&INFO);

    dgetrs_(&TRANS,&N,&NRHS,A,&LDA,IPIV,B,&LDB,&INFO);

    std::cout << "[" << B[0] << ", " << B[1] <<", " << B[2] << "]" << std::endl;

#endif

  return 0;
}

