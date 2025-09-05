cmake_minimum_required( VERSION 3.18 FATAL_ERROR )

find_package( ecbuild REQUIRED )
project( test_test_custom_build_type VERSION 0.1.0 LANGUAGES Fortran C CXX )

ecbuild_enable_fortran (REQUIRED)

ecbuild_add_executable (TARGET proj SOURCES proj.F90)

