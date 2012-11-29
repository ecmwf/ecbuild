###############################################################################
# cmake
#   options:
#       -DCMAKE_BUILD_TYPE=Debug|RelWithDebInfo|Release|Production
#       -DCMAKE_INSTALL_PREFIX=/path/to/install
#
#       -DCMAKE_C_COMPILER=gcc
#       -DCMAKE_CXX_COMPILER=g++
#
#       -DCMAKE_MODULE_PATH=/path/to/ecbase/cmake
#       -DCMAKE_PREFIX_PATH=/path/to/jasper:/path/to/any/package/out/of/place

cmake_minimum_required( VERSION 2.6.4 FATAL_ERROR )

project( foo )

set( CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/cmake" ${CMAKE_MODULE_PATH} )

include( ecmwf_build_system )

###############################################################################
# local project

ecmwf_declare_project()

###############################################################################
# some variables/options of this project

###############################################################################
# find extra packages

###############################################################################
# contents

ecmwf_add_library( TARGET       foo
                   SOURCES      foo.h foo.c )

ecmwf_add_executable( TARGET     master_foo
                      SOURCES    main.cc
                      LIBS       foo )

ecmwf_add_test( TARGET   test_foo
                SOURCES  test.cc
                LIBS     foo )

if( NOT ${PROJECT_NAME} STREQUAL ${CMAKE_PROJECT_NAME} )
  set( FOO_INCLUDE_DIRS   ${CMAKE_CURRENT_SOURCE_DIR} PARENT_SCOPE )
  set( FOO_LIBRARIES      foo  PARENT_SCOPE )
  set( FOO_FOUND          TRUE PARENT_SCOPE )
endif()

############################################################################################
# installation 

ecmwf_install_project( NAME Foo )

###############################################################################
# summary

# print the summary of the configuration
include( ecmwf_print_summary )

