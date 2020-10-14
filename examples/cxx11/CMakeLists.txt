# (C) Copyright 2011- ECMWF.
#
# This software is licensed under the terms of the Apache Licence Version 2.0
# which can be obtained at http://www.apache.org/licenses/LICENSE-2.0.
# In applying this licence, ECMWF does not waive the privileges and immunities
# granted to it by virtue of its status as an intergovernmental organisation
# nor does it submit to any jurisdiction.

cmake_minimum_required( VERSION 3.11 FATAL_ERROR )

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
