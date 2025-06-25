# (C) Copyright 2011- ECMWF.
#
# This software is licensed under the terms of the Apache Licence Version 2.0
# which can be obtained at http://www.apache.org/licenses/LICENSE-2.0.
# In applying this licence, ECMWF does not waive the privileges and immunities
# granted to it by virtue of its status as an intergovernmental organisation
# nor does it submit to any jurisdiction.

cmake_minimum_required( VERSION 3.18 FATAL_ERROR )

find_package(ecbuild REQUIRED)

if( SUBPROJ2_CONFIG )
    set( ECBUILD_CONFIG ${SUBPROJ2_CONFIG} )
endif()

project( subproj_2 VERSION 0.2 LANGUAGES C )

ecbuild_debug_var( CMAKE_C_FLAGS )
ecbuild_debug_var( CMAKE_C_FLAGS_DEBUG )
