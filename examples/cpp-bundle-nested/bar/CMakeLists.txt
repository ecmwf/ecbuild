# (C) Copyright 2011- ECMWF.
#
# This software is licensed under the terms of the Apache Licence Version 2.0
# which can be obtained at http://www.apache.org/licenses/LICENSE-2.0.
# In applying this licence, ECMWF does not waive the privileges and immunities
# granted to it by virtue of its status as an intergovernmental organisation
# nor does it submit to any jurisdiction.

cmake_minimum_required( VERSION 3.11 FATAL_ERROR )

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
