cmake_minimum_required(VERSION 3.11 FATAL_ERROR)
find_package( ecbuild 3.0.0 REQUIRED )
project( find_fftw VERSION 0.0.0 LANGUAGES CXX )

ecbuild_find_package( NAME FFTW REQUIRED COMPONENTS single )

### Try to link executable with FFTW_LIBRARIES

ecbuild_add_test( TARGET  test_fftw 
                  SOURCES test_fftw.cc
                  LIBS    FFTW::fftw3f )
