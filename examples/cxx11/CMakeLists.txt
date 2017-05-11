cmake_minimum_required( VERSION 2.8.12 FATAL_ERROR )

project( cxx11 CXX )

set( CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} "${CMAKE_CURRENT_SOURCE_DIR}/../../cmake" )

include( ecbuild_system NO_POLICY_SCOPE )

ecbuild_requires_macro_version( 1.9 )

### open project

ecbuild_declare_project()

### definitions

ecbuild_add_cxx11_flags()

### targets

ecbuild_add_executable( TARGET compute
                        SOURCES compute.cc )

### pkgconfig exports

ecbuild_pkgconfig()

### finalize project

ecbuild_install_project( NAME ${PROJECT_NAME} )

ecbuild_print_summary()
