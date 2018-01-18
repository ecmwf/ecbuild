# (C) Copyright 1996 ECMWF.
#
# This software is licensed under the terms of the Apache Licence Version 2.0
# which can be obtained at http://www.apache.org/licenses/LICENSE-2.0.
# In applying this licence, ECMWF does not waive the privileges and immunities
# granted to it by virtue of its status as an intergovernmental organisation
# nor does it submit to any jurisdiction.

cmake_minimum_required( VERSION 2.8.12 FATAL_ERROR )

project( bar C CXX )

set( CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/cmake" ${CMAKE_MODULE_PATH} "${CMAKE_CURRENT_SOURCE_DIR}/../ecbuild/cmake")

include( ecbuild_system NO_POLICY_SCOPE )

ecbuild_requires_macro_version( 2.7 )

### open project

ecbuild_declare_project()

### targets

ecbuild_bundle( PROJECT foo )

ecbuild_add_library( TARGET            bar
                     PRIVATE_INCLUDES  ${FOO_INCLUDE_DIRS}
                     LIBS              foo
                     SOURCES           bar.h bar.c )

ecbuild_add_executable(
    TARGET     master_bar
    SOURCES    main.cc
    INCLUDES   ${FOO_INCLUDE_DIRS}
    LIBS       bar
)

ecbuild_add_test(
    TARGET     test_bar
    SOURCES    test.cc
    LIBS       bar
)

ecbuild_install_project( NAME ${PROJECT_NAME} )

ecbuild_print_summary()
