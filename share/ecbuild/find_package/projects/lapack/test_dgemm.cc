
extern "C" {
  void dgemm_(const char* transa, const char* transb, const int* m, const int* n, const int* k, const double* alpha,
              const double* a, const int* lda, const double* b, const int* ldb, const double* beta, double* c,
              const int* ldc);
}

#include <iostream>

static const char* trans  = "N";
static const int inc      = 1;
static const double alpha = 1.;
static const double beta  = 0.;

int main(int argc, char* argv[] ) {
  int err_code = 0;
  double A[] = { 1., -2., -4., 2. };
  double B[] = { 1., -2., -4., 2. };
  double C[] = { 0.,  0.,  0., 0. };
  double C_expected[] = { 9., -6., -12., 12. };

  int m = 2; // A.rows()
  int n = 2; // B.cols()
  int k = 2; // A.cols()
  dgemm_( trans, trans, &m, &n, &k, &alpha, A, &m, B, &k, &beta, C, &m); 

  for( int i=0; i<2; ++i ) {
    for( int j=0; j<2; ++j ) {
      int idx = i*2+j;
      if( std::abs( C[idx] - C_expected[idx] ) > 1.e-10 ) {
        err_code=1;
        std::cout << "C("<<i<<","<<j<<") is not as expected " << std::endl;
      }
    }
  }

  if( err_code == 0 ) {
    std::cout << "Test passed" << std::endl;
  }
  else {
    std::cout << "Test failed" << std::endl;
  }
  return err_code;
}

