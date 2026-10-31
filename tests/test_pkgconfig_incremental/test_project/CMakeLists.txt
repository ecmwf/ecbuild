# (C) Copyright 2026- ECMWF.
#
# This software is licensed under the terms of the Apache Licence Version 2.0
# which can be obtained at http://www.apache.org/licenses/LICENSE-2.0.
# In applying this licence, ECMWF does not waive the privileges and immunities
# granted to it by virtue of its status as an intergovernmental organisation nor
# does it submit to any jurisdiction.

cmake_minimum_required(VERSION 3.18 FATAL_ERROR)
find_package(ecbuild REQUIRED)
project(pkgconfig_incremental VERSION 0.1 LANGUAGES NONE)

add_library(example INTERFACE)
ecbuild_pkgconfig(NAME example LIBRARIES example)

# A call from a subdirectory configures its script below that directory.
add_subdirectory(sub)
