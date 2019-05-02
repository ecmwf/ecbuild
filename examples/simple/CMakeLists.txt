cmake_minimum_required( VERSION 2.8.12 FATAL_ERROR )

set( CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} "${CMAKE_CURRENT_SOURCE_DIR}/../../cmake" )

include(ecbuild)

project( simple CXX Fortran )

### declare options

ecbuild_add_option( FEATURE MATRIX
                    DESCRIPTION "Use matrix operations"
                    REQUIRED_PACKAGES LAPACK )

ecbuild_add_option( FEATURE BESSEL
                    CONDITION HAVE_MATRIX
                    DESCRIPTION "Compute Bessel function"
                    REQUIRED_PACKAGES GSL )

### targets

add_subdirectory( circle )

add_subdirectory( compute )

### pkgconfig exports

ecbuild_pkgconfig(
    NAME circle
    DESCRIPTION "Functions on circles"
    LIBRARIES circle )

### finalize project

ecbuild_install_project( NAME ${PROJECT_NAME} )

ecbuild_print_summary()
