# (C) Copyright 1996 ECMWF.
#
# This software is licensed under the terms of the Apache Licence Version 2.0
# which can be obtained at http://www.apache.org/licenses/LICENSE-2.0.
# In applying this licence, ECMWF does not waive the privileges and immunities
# granted to it by virtue of its status as an intergovernmental organisation
# nor does it submit to any jurisdiction.

cmake_minimum_required( VERSION 2.8.11 FATAL_ERROR )

project( subproj_2 C )

set( CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/../../../cmake" ${CMAKE_MODULE_PATH} )

if( SUBPROJ2_CONFIG )
    set( ECBUILD_CONFIG ${SUBPROJ2_CONFIG} )
endif()

include( ecbuild_system NO_POLICY_SCOPE )

ecbuild_requires_macro_version( 2.0 )

### open project

ecbuild_declare_project()

ecbuild_debug_var( CMAKE_C_FLAGS )
ecbuild_debug_var( CMAKE_C_FLAGS_DEBUG )
