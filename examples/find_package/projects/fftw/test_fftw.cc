#include <cmath>
#include <cstddef>
#include <vector>
#include <iostream>

#include "fftw3.h"

struct FFTW_Data {
    fftwf_complex* in;
    float* out;
    fftwf_plan plan;
};

int main(int argc, char* argv[] ) {
  int err_code = 0;

  int nlats = 32;
  int nlons = 64;
  int jlonMin_ = 0;

  FFTW_Data* fftw = new FFTW_Data;

  int num_complex = ( nlons / 2 ) + 1;

  fftw->in  = fftwf_alloc_complex( nlats * num_complex );
  fftw->out = fftwf_alloc_real( nlats * nlons );

  fftw->plan =
     fftwf_plan_many_dft_c2r( 1, &nlons, nlats, fftw->in, nullptr, 1, num_complex,
                             fftw->out, nullptr, 1, nlons, FFTW_ESTIMATE );

  int idx = 0;
  for ( int jlat = 0; jlat < nlats; jlat++ ) {
      fftw->in[idx++][0] = 0.;
      for ( int jm = 1; jm < num_complex; jm++, idx++ ) {
          for ( int imag = 0; imag < 2; imag++ ) {
            fftw->in[idx][imag] = 0.;
          }
      }
  }
  fftwf_execute_dft_c2r( fftw->plan, fftw->in, fftw->out );
  for ( int jlat = 0; jlat < nlats; jlat++ ) {
      for ( int jlon = 0; jlon < nlons; jlon++ ) {
          int j = jlon + jlonMin_;
          double gp_value /* [jlon + nlons * (jlat + nlats )] */ = fftw->out[j + nlons * jlat];
          if( std::abs( gp_value - 0. ) > 1.e-10 ) {
            err_code = 1.;
          }
      }
  }


  fftwf_destroy_plan( fftw->plan );
  fftwf_free( fftw->in );
  fftwf_free( fftw->out );

  delete fftw;


  if( err_code == 0 ) {
    std::cout << "Test passed" << std::endl;
  }
  else {
    std::cout << "Test failed" << std::endl;
  }
  return err_code;
}

