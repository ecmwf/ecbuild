# SPDX-FileCopyrightText: 2011- European Centre for Medium-Range Weather Forecasts (ECMWF)
# SPDX-License-Identifier: Apache-2.0

cmake_minimum_required( VERSION 3.18 FATAL_ERROR )

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
