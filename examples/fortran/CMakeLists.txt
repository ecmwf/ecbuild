cmake_minimum_required( VERSION 2.8.4 FATAL_ERROR )

project( compute_circle Fortran )

set( CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/cmake" ${CMAKE_MODULE_PATH} "${CMAKE_CURRENT_SOURCE_DIR}/../ecbuild/cmake")

include( ecbuild_system NO_POLICY_SCOPE )

ecbuild_requires_macro_version( 1.9 )

### open project

ecbuild_declare_project()

### options

ecbuild_add_option( FEATURE AREA_COMPUTER
                    DESCRIPTION "Wether we should build the area_computer executable" )

### lib const

ecbuild_add_library(
    TARGET  const
    TYPE    STATIC
    SOURCES constants.f90
    )


### lib area_circle

file( GLOB area_srcs RELATIVE ${CMAKE_CURRENT_SOURCE_DIR} "*circle.f90" )

ecbuild_add_library(
    TARGET area_circle
    SOURCES ${area_srcs}
    LIBS const
    )

# application conditionally compiled

ecbuild_add_executable(
    TARGET  area_computer
    SOURCES main.F90
    CONDITION
    LIBS area_circle
    )

### finalize project

ecbuild_pkgconfig(
    NAME area_circle
    DESCRIPTION "A library to compute the area of a circle"
    LIBRARIES area_circle
    )

ecbuild_install_project( NAME ${PROJECT_NAME} )

ecbuild_print_summary()