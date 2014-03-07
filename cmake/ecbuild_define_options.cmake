# (C) Copyright 1996-2012 ECMWF.
# 
# This software is licensed under the terms of the Apache Licence Version 2.0
# which can be obtained at http://www.apache.org/licenses/LICENSE-2.0. 
# In applying this licence, ECMWF does not waive the privileges and immunities 
# granted to it by virtue of its status as an intergovernmental organisation nor
# does it submit to any jurisdiction.

# general options

option( BUILD_SHARED_LIBS       "build shared libraries when possible"            ON  )

option( ENABLE_RPATHS           "when installing insert RPATHS into binaries"     ON  )
option( ENABLE_WARNINGS         "enable compiler warnings"                        OFF )

option( CHECK_UNUSED_FILES      "check for unused project files"                  ON  )

option( ENABLE_LARGE_FILE_SUPPORT "build with large file support"   ON  )

option( ENABLE_OS_TESTS          "Run all OS tests" ON )

include( CMakeDependentOption ) # make options depend on one another

cmake_dependent_option( ENABLE_OS_TYPES_TEST     "Run sizeof tests on C types" ON "ENABLE_OS_TESTS" OFF)
cmake_dependent_option( ENABLE_OS_ENDINESS_TEST  "Run OS endiness tests"       ON "ENABLE_OS_TESTS" OFF)
cmake_dependent_option( ENABLE_OS_FUNCTIONS_TEST "Run OS functions tests"      ON "ENABLE_OS_TESTS" OFF)

mark_as_advanced( ENABLE_OS_TYPES_TEST ENABLE_OS_ENDINESS_TEST ENABLE_OS_FUNCTIONS_TEST  )
