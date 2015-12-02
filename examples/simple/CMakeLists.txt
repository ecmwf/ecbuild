cmake_minimum_required( VERSION 2.8.12 FATAL_ERROR )

project( simple CXX Fortran )

set( CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} "${CMAKE_CURRENT_SOURCE_DIR}/../../cmake" )

include( ecbuild_system NO_POLICY_SCOPE )

ecbuild_requires_macro_version( 1.9 )

### open project

ecbuild_declare_project()

### declare options

ecbuild_add_option( FEATURE BESSEL
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
