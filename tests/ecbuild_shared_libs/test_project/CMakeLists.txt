# SPDX-FileCopyrightText: 2011- European Centre for Medium-Range Weather Forecasts (ECMWF)
# SPDX-License-Identifier: Apache-2.0

cmake_minimum_required( VERSION 3.18 FATAL_ERROR )

find_package( ecbuild REQUIRED )
project( test_shared_libs VERSION 0.1.0 LANGUAGES Fortran )

ecbuild_add_library( TARGET test_shared_libs SOURCES dummy_src.F90 )

# this should never be overriden
ecbuild_add_library( TARGET lib1 TYPE SHARED SOURCES dummy_src.F90 )

ecbuild_add_library( TARGET lib2 SOURCES dummy_src.F90 )
