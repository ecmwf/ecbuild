# (C) Copyright 2011- ECMWF.
#
# This software is licensed under the terms of the Apache Licence Version 2.0
# which can be obtained at http://www.apache.org/licenses/LICENSE-2.0.
# In applying this licence, ECMWF does not waive the privileges and immunities
# granted to it by virtue of its status as an intergovernmental organisation
# nor does it submit to any jurisdiction.

cmake_minimum_required( VERSION 2.8.4 FATAL_ERROR )

project( mypython CXX )

set( CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} "${CMAKE_CURRENT_SOURCE_DIR}/../../cmake" )

include( ecbuild_system )

ecbuild_declare_project()

###############################################################################
# find extra packages

# Python
# Can specify non-default distribution with CMake variable PYTHON_EXECUTABLE
ecbuild_find_python()
ecbuild_info("PYTHON_EXECUTABLE    : ${PYTHON_EXECUTABLE}")
ecbuild_info("PYTHON_INCLUDE_DIRS  : ${PYTHON_INCLUDE_DIRS}")
ecbuild_info("PYTHON_LIBRARIES     : ${PYTHON_LIBRARIES}")

# Boost
# Can specify non-default distribution with CMake variable BOOST_ROOT
ecbuild_add_extra_search_paths( boost )
set( Boost_MINIMUM_VERSION "1.47" )
find_package( Boost ${Boost_MINIMUM_VERSION} REQUIRED
              COMPONENTS python )
ecbuild_info("Boost_LIBRARIES     : ${Boost_LIBRARIES}" )

###############################################################################
# Contents

ecbuild_add_library( TARGET       mypython
                     INCLUDES     ${Boost_INCLUDE_DIR} ${PYTHON_INCLUDE_DIRS}
                     LIBS         ${Boost_LIBRARIES} ${PYTHON_LIBRARIES}
                     SOURCES      pythonlib.hpp pythonlib.cpp )
configure_file( mypython.py       ${CMAKE_BINARY_DIR}/lib COPYONLY )

############################################################################################
# Installation

ecbuild_install_project( NAME python_project )

###############################################################################
# Summary

ecbuild_print_summary()



ecbuild_info( "" )
ecbuild_info( "To test the library:" )
ecbuild_info( "--------------------" )
ecbuild_info( "make" )
ecbuild_info( "cd ${CMAKE_CURRENT_BINARY_DIR}/lib" )
ecbuild_info( "python" )
ecbuild_info( ">>> import libmypython" )
ecbuild_info( ">>> help(libmypython)" )
ecbuild_info( "" )
ecbuild_info( "---------------------------------------------------------" )
