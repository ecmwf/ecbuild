cmake_minimum_required( VERSION 3.18 FATAL_ERROR )

find_package( ecbuild 3.4 REQUIRED )
project( find_fftw VERSION 0.0.0 LANGUAGES CXX )

# Provide FFTW_ENABLE_MKL=ON  to force MKL implementation
# Provide FFTW_ENABLE_MKL=OFF to force no MKL implementation
# Not providing FFTW_ENABLE_MKL will prefer MKL implementation and fall back to official FFTW

ecbuild_find_package( NAME FFTW REQUIRED COMPONENTS single )

### Try to link executable with FFTW_LIBRARIES

ecbuild_add_test( TARGET  test_fftw 
                  SOURCES test_fftw.cc
                  LIBS    FFTW::fftw3f )
