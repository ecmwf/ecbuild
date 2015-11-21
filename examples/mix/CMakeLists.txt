cmake_minimum_required( VERSION 2.8.12 FATAL_ERROR )

project( mix CXX Fortran )

set( CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/cmake" ${CMAKE_MODULE_PATH} "${CMAKE_CURRENT_SOURCE_DIR}/../ecbuild/cmake")

include( ecbuild_system NO_POLICY_SCOPE )

ecbuild_requires_macro_version( 1.9 )

### open project

ecbuild_declare_project()

### targets

add_subdirectory( fort )

add_subdirectory( cpp )

### pkgconfig exports

ecbuild_pkgconfig( NAME fortbar DESCRIPTION "A fortran library bar" LIBRARIES fortbar )
ecbuild_pkgconfig( NAME fortbaz DESCRIPTION "A fortran library baz" LIBRARIES fortbaz )

### finalize project

ecbuild_install_project( NAME ${PROJECT_NAME} )

ecbuild_print_summary()