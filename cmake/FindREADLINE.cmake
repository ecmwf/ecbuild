# (C) Copyright 1996-2012 ECMWF.
# 
# This software is licensed under the terms of the Apache Licence Version 2.0
# which can be obtained at http://www.apache.org/licenses/LICENSE-2.0. 
# In applying this licence, ECMWF does not waive the privileges and immunities 
# granted to it by virtue of its status as an intergovernmental organisation nor
# does it submit to any jurisdiction.

# - Try to find READLINE
# Once done this will define
#  READLINE_FOUND - System has READLINE
#  READLINE_INCLUDE_DIRS - The READLINE include directories
#  READLINE_LIBRARIES - The libraries needed to use READLINE
#  READLINE_DEFINITIONS - Compiler switches required for using READLINE

if( DEFINED READLINE_PATH )
    find_path(READLINE_INCLUDE_DIR readline/readline.h PATHS ${READLINE_PATH}/include NO_DEFAULT_PATH)
    find_library(READLINE_LIBRARY  readline            PATHS ${READLINE_PATH}/lib     PATH_SUFFIXES readline NO_DEFAULT_PATH)
endif()

find_path(READLINE_INCLUDE_DIR readline/readline.h )
find_library( READLINE_LIBRARY readline            PATH_SUFFIXES readline )

set( READLINE_LIBRARIES    ${READLINE_LIBRARY} )
set( READLINE_INCLUDE_DIRS ${READLINE_INCLUDE_DIR} )

include(FindPackageHandleStandardArgs)

find_package_handle_standard_args(READLINE  DEFAULT_MSG READLINE_LIBRARY READLINE_INCLUDE_DIR)

mark_as_advanced(READLINE_INCLUDE_DIR READLINE_LIBRARY )
