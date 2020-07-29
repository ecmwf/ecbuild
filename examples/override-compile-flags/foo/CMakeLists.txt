# (C) Copyright 2011- ECMWF.
#
# This software is licensed under the terms of the Apache Licence Version 2.0
# which can be obtained at http://www.apache.org/licenses/LICENSE-2.0.
# In applying this licence, ECMWF does not waive the privileges and immunities
# granted to it by virtue of its status as an intergovernmental organisation
# nor does it submit to any jurisdiction.

cmake_minimum_required( VERSION 3.11 FATAL_ERROR )

find_package( ecbuild REQUIRED )
project( foo VERSION 0.1 LANGUAGES Fortran C )

ecbuild_enable_fortran ( REQUIRED MODULE_DIRECTORY ${CMAKE_BINARY_DIR}/module )

ecbuild_find_package( NAME bar REQUIRED )

### targets

ecbuild_add_library( TARGET       foo
                     SOURCES      foo.c
                                  foo.f90
                                  foo_contiguous.f90
                                  foo_intolerant.f90
                                  foo_ivybridge.f90
                                  foo_no_debug_symbols.f90
                     PRIVATE_LIBS bar )

ecbuild_install_project( NAME ${PROJECT_NAME} )

ecbuild_print_summary()
