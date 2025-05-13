cmake_minimum_required( VERSION 3.18 FATAL_ERROR )

find_package( ecbuild 3.0.0 REQUIRED )
project( find_proj4  VERSION 0.0.0 LANGUAGES C CXX Fortran )

find_package( PROJ4 6 )

if( NOT TARGET PROJ4::proj )
  ecbuild_error( "PROJ4::proj target undefined" )
endif()

ecbuild_add_test( TARGET main SOURCES example.c LIBS PROJ4::proj )

