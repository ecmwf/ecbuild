# SPDX-FileCopyrightText: 2011- European Centre for Medium-Range Weather Forecasts (ECMWF)
# SPDX-License-Identifier: Apache-2.0

cmake_minimum_required( VERSION 3.18 FATAL_ERROR )

find_package( ecbuild REQUIRED )
project( bar VERSION 1.0.0 LANGUAGES C CXX )

### targets

ecbuild_bundle( PROJECT foo )

ecbuild_add_library( TARGET            bar
                     PUBLIC_LIBS       foo
                     SOURCES           bar.h bar.c
                     PUBLIC_INCLUDES
                        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}> )

ecbuild_add_executable(
    TARGET     master_bar
    SOURCES    main.cc
    LIBS       bar
)

ecbuild_add_test(
    TARGET     test_bar
    SOURCES    test.cc
    LIBS       bar
)

ecbuild_install_project( NAME ${PROJECT_NAME} )

ecbuild_print_summary()
