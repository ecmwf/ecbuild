# SPDX-FileCopyrightText: 2011- European Centre for Medium-Range Weather Forecasts (ECMWF)
# SPDX-License-Identifier: Apache-2.0

cmake_minimum_required( VERSION 3.18 FATAL_ERROR )

find_package( ecbuild REQUIRED )
project( mix VERSION 0.10.0 LANGUAGES CXX Fortran )

### targets

add_subdirectory( fort )

add_subdirectory( cpp )

### pkgconfig exports

ecbuild_pkgconfig( NAME fortbar DESCRIPTION "A fortran library bar" LIBRARIES fortbar )
ecbuild_pkgconfig( NAME fortbaz DESCRIPTION "A fortran library baz" LIBRARIES fortbaz )

### finalize project

ecbuild_install_project( NAME ${PROJECT_NAME} )

ecbuild_print_summary()
