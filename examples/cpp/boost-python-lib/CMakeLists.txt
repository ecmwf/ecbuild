
cmake_minimum_required( VERSION 2.8.4 FATAL_ERROR )

project( mypython CXX )

set( CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/cmake" ${CMAKE_MODULE_PATH} )

include( ecbuild_system )

ecbuild_declare_project()

###############################################################################
# find extra packages

# Python
# Can specify non-default distribution with CMake variable PYTHON_EXECUTABLE
ecbuild_find_python()
message( STATUS "PYTHON_EXECUTABLE    : ${PYTHON_EXECUTABLE}")
message( STATUS "PYTHON_INCLUDE_DIRS  : ${PYTHON_INCLUDE_DIRS}")
message( STATUS "PYTHON_LIBRARIES     : ${PYTHON_LIBRARIES}")

# Boost
# Can specify non-default distribution with CMake variable BOOST_ROOT
ecbuild_add_extra_search_paths( boost )
set( Boost_MINIMUM_VERSION "1.47" )
find_package( Boost ${Boost_MINIMUM_VERSION} REQUIRED
              COMPONENTS python )
message( STATUS "Boost_LIBRARIES     : ${Boost_LIBRARIES}" )

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



message( STATUS "" )
message( STATUS "To test the library:" )
message( STATUS "--------------------" )
message( STATUS "make" )
message( STATUS "cd ${CMAKE_CURRENT_BINARY_DIR}/lib" )
message( STATUS "python" )
message( STATUS ">>> import libmypython" )
message( STATUS ">>> help(libmypython)" )
message( STATUS "" )
message( STATUS "---------------------------------------------------------" )