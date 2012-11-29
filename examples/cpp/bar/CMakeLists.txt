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

project( bar )

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

ecmwf_add_subproject( foo  ON  )

ecmwf_add_library( TARGET       bar
                   INCLUDES     ${FOO_INCLUDE_DIRS}
                   LIBS         ${FOO_LIBRARIES}
                   SOURCES      bar.h bar.c )

ecmwf_add_executable( TARGET     master_bar
                      SOURCES    main.cc
                      LIBS       bar )

ecmwf_add_test( TARGET   test_bar
                SOURCES  test.cc
                LIBS     bar )

############################################################################################
# installation 

ecmwf_install_project( NAME Bar )

###############################################################################
# summary

# print the summary of the configuration
include( ecmwf_print_summary )

