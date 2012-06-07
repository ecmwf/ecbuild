# © Copyright 1996-2012 ECMWF.
# 
# This software is licensed under the terms of the Apache Licence Version 2.0
# which can be obtained at http://www.apache.org/licenses/LICENSE-2.0. 
# In applying this licence, ECMWF does not waive the privileges and immunities 
# granted to it by virtue of its status as an intergovernmental organisation nor
# does it submit to any jurisdiction.

############################################################################################
# disallow in-source build

if("${CMAKE_SOURCE_DIR}" STREQUAL "${CMAKE_BINARY_DIR}")
  message(FATAL_ERROR
    "${PROJECT_NAME} requires an out of source build.\n
    Please create a separate build directory and run 'cmake path/to/project [options]' from there.")
endif()

############################################################################################
# define a Production build type

SET( CMAKE_CXX_FLAGS_PRODUCTION "-O3" CACHE STRING
    "Flags used by the C++ compiler during Production builds."
    FORCE )
SET( CMAKE_C_FLAGS_PRODUCTION "-O3" CACHE STRING
    "Flags used by the C compiler during Production builds."
    FORCE )
SET( CMAKE_EXE_LINKER_FLAGS_PRODUCTION
    "" CACHE STRING
    "Flags used for linking binaries during Production builds."
    FORCE )
SET( CMAKE_SHARED_LINKER_FLAGS_PRODUCTION
    "" CACHE STRING
    "Flags used by the shared libraries linker during Production builds."
    FORCE )
MARK_AS_ADVANCED(
    CMAKE_CXX_FLAGS_PRODUCTION
    CMAKE_C_FLAGS_PRODUCTION
    CMAKE_EXE_LINKER_FLAGS_PRODUCTION
    CMAKE_SHARED_LINKER_FLAGS_PRODUCTION )

############################################################################################
# define default build type

if(NOT CMAKE_BUILD_TYPE)
  set(CMAKE_BUILD_TYPE RelWithDebInfo CACHE STRING
      "Choose the type of build, options are: None Debug Production Release RelWithDebInfo Production."
      FORCE)
endif()

# capitalize the build type to use with conditionals
string( TOUPPER ${CMAKE_BUILD_TYPE} MARS_BUILD_TYPE )

# fail if build type is not one of the defined ones
if( NOT CMAKE_BUILD_TYPE MATCHES "None"  AND
    NOT CMAKE_BUILD_TYPE MATCHES "Debug" AND
    NOT CMAKE_BUILD_TYPE MATCHES "Production" AND
    NOT CMAKE_BUILD_TYPE MATCHES "Release"  AND
    NOT CMAKE_BUILD_TYPE MATCHES "RelWithDebInfo" )
    message( FATAL_ERROR "CMAKE_BUILD_TYPE is not one of [ None | Debug | Production | Release | RelWithDebInfo | Production ]" )
endif()

############################################################################################
# add cmake macros

include(CheckTypeSize)
include(CheckIncludeFile)
include(CheckIncludeFileCXX)
include(CheckIncludeFiles)
include(CheckFunctionExists)
include(CheckSymbolExists)
include(CheckCSourceCompiles)
include(CheckCXXSourceCompiles)
include(CheckCCompilerFlag)
include(CheckCXXCompilerFlag)

include(TestBigEndian)

############################################################################################
# add our macros

include( ecmwf_debug_var )
include( ecmwf_add_persistent )
include( ecmwf_generate_yy )
include( ecmwf_add_library )
include( ecmwf_add_executable )
include( ecmwf_add_test )
include( ecmwf_project_files )

############################################################################################
# more macros

macro(TODAY RESULT)
    if(UNIX)
        execute_process(COMMAND "date" "+%d/%m/%Y" OUTPUT_VARIABLE ${RESULT})
        string(REGEX REPLACE "(..)/(..)/(....).*" "\\3.\\2.\\1" ${RESULT} ${${RESULT}})
    else()
        message(SEND_ERROR "date not implemented")
    endif()
endmacro(TODAY)

