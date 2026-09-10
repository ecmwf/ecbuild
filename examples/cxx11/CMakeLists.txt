# SPDX-FileCopyrightText: 2011- European Centre for Medium-Range Weather Forecasts (ECMWF)
# SPDX-License-Identifier: Apache-2.0

cmake_minimum_required( VERSION 3.18 FATAL_ERROR )

find_package(ecbuild REQUIRED)
project( cxx11 VERSION 0.0.1 LANGUAGES CXX )

### definitions

set(CMAKE_CXX_STANDARD 11)

### targets

ecbuild_add_executable( TARGET compute
                        SOURCES compute.cc )

### finalize project

ecbuild_install_project( NAME ${PROJECT_NAME} )

ecbuild_print_summary()
