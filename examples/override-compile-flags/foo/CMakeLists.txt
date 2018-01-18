# (C) Copyright 1996 ECMWF.
#
# This software is licensed under the terms of the Apache Licence Version 2.0
# which can be obtained at http://www.apache.org/licenses/LICENSE-2.0.
# In applying this licence, ECMWF does not waive the privileges and immunities
# granted to it by virtue of its status as an intergovernmental organisation
# nor does it submit to any jurisdiction.

cmake_minimum_required( VERSION 3.3.2 FATAL_ERROR )

project( foo Fortran C )

set( CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} "${CMAKE_CURRENT_SOURCE_DIR}/../ecbuild/cmake" )

include( ecbuild_system NO_POLICY_SCOPE )

ecbuild_requires_macro_version( 2.0 )

### open project

ecbuild_declare_project()

ecbuild_enable_fortran ( REQUIRED MODULE_DIRECTORY ${CMAKE_BINARY_DIR}/module )

ecbuild_use_package( PROJECT bar REQUIRED )

### targets

ecbuild_add_library( TARGET  foo
                     SOURCES foo.c
                             foo.f90
                             foo_contiguous.f90
                             foo_intolerant.f90
                             foo_ivybridge.f90
                             foo_no_debug_symbols.f90
                     LIBS    bar )

ecbuild_install_project( NAME ${PROJECT_NAME} )

ecbuild_print_summary()
