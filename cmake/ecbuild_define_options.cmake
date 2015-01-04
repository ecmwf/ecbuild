# (C) Copyright 1996-2014 ECMWF.
# 
# This software is licensed under the terms of the Apache Licence Version 2.0
# which can be obtained at http://www.apache.org/licenses/LICENSE-2.0. 
# In applying this licence, ECMWF does not waive the privileges and immunities 
# granted to it by virtue of its status as an intergovernmental organisation nor
# does it submit to any jurisdiction.

# general options

option( BUILD_SHARED_LIBS       "build shared libraries when possible"            ON  )

option( ENABLE_RPATHS           "when installing insert RPATHS into binaries"     ON  )
option( ENABLE_RELATIVE_RPATHS  "try to use relative RPATHS, including build dir" ON  )
option( ENABLE_WARNINGS         "enable compiler warnings"                        OFF )

option( ENABLE_LARGE_FILE_SUPPORT "build with large file support"   ON  )

mark_as_advanced( ENABLE_LARGE_FILE_SUPPORT )

option( ENABLE_OS_TESTS          "Run all OS tests" ON )

mark_as_advanced( ENABLE_OS_TESTS )

option( DEVELOPER_MODE           "activates developer mode"               OFF )
option( CHECK_UNUSED_FILES       "check for unused project files"         ON )

mark_as_advanced( DEVELOPER_MODE  )
mark_as_advanced( CHECK_UNUSED_FILES  )

include( CMakeDependentOption ) # make options depend on one another

cmake_dependent_option( ENABLE_OS_TYPES_TEST     "Run sizeof tests on C types" ON "ENABLE_OS_TESTS" OFF)
cmake_dependent_option( ENABLE_OS_ENDINESS_TEST  "Run OS endiness tests"       ON "ENABLE_OS_TESTS" OFF)
cmake_dependent_option( ENABLE_OS_FUNCTIONS_TEST "Run OS functions tests"      ON "ENABLE_OS_TESTS" OFF)

mark_as_advanced( ENABLE_OS_TYPES_TEST ENABLE_OS_ENDINESS_TEST ENABLE_OS_FUNCTIONS_TEST  )

# set policies

# for macosx use @rpath in a target’s install name
if( POLICY CMP0042 )
	cmake_policy( SET CMP0042 NEW )
	set( CMAKE_MACOSX_RPATH ON )
endif()

# inside if() don't dereference variables if they are quoted e.g. "VAR", only dereference with "${VAR}"
if( POLICY CMP0054 )
	cmake_policy( SET CMP0054 NEW )
endif()
