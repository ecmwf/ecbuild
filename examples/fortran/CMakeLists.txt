# (C) Copyright 1996 ECMWF.
#
# This software is licensed under the terms of the Apache Licence Version 2.0
# which can be obtained at http://www.apache.org/licenses/LICENSE-2.0.
# In applying this licence, ECMWF does not waive the privileges and immunities
# granted to it by virtue of its status as an intergovernmental organisation
# nor does it submit to any jurisdiction.

cmake_minimum_required( VERSION 2.8.12 FATAL_ERROR )

project( compute_circle Fortran )

set( CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} "${CMAKE_CURRENT_SOURCE_DIR}/../../cmake")

include( ecbuild_system NO_POLICY_SCOPE )

ecbuild_requires_macro_version( 2.0 )

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

ecbuild_list_add_pattern( LIST area_srcs GLOB "*.f*" )

ecbuild_list_exclude_pattern( LIST area_srcs REGEX old.*f90 ^const.* .*f95 main.[fF]90 api/* )

ecbuild_generate_fortran_interfaces(

    TARGET      intf_circ

    SOURCE_DIR  ${CMAKE_CURRENT_SOURCE_DIR}

    DIRECTORIES api/area api/volume

    DESTINATION  api

    INCLUDE_DIRS intf_circ_includes
)

ecbuild_add_library(

    TARGET  api_objs

    TYPE    OBJECT

    SOURCES_GLOB  "api/area/*.F90" "api/volume/*.F90"
)

ecbuild_debug( "intf_circ_includes" )

ecbuild_debug_var( intf_circ_includes )

ecbuild_add_library(
    TARGET  area_circle
    SOURCES ${area_srcs}
    OBJECTS api_objs
    LIBS    const
    DEPENDS intf_circ
)

# application conditionally compiled

ecbuild_add_executable(
    TARGET  area_computer
    SOURCES main.F90
    LIBS area_circle
    CONDITION HAVE_AREA_COMPUTER
    )

### finalize project

ecbuild_pkgconfig(
    NAME area_circle
    DESCRIPTION "A library to compute the area of a circle"
    LIBRARIES area_circle
    )

ecbuild_install_project( NAME ${PROJECT_NAME} )

ecbuild_print_summary()
