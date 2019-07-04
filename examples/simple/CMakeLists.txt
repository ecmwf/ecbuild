cmake_minimum_required( VERSION 3.6 FATAL_ERROR )

find_package(ecbuild REQUIRED)

project( simple VERSION 0.10.0 LANGUAGES C CXX Fortran )

### declare options

find_package(LAPACK QUIET)
ecbuild_add_option( FEATURE MATRIX
                    DESCRIPTION "Use matrix operations"
                    CONDITION LAPACK_FOUND )

find_package(GSL QUIET)
ecbuild_add_option( FEATURE BESSEL
                    DESCRIPTION "Compute Bessel function"
                    CONDITION HAVE_MATRIX AND GSL_FOUND )

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
