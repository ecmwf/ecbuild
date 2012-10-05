# (C) Copyright 1996-2012 ECMWF.
#
# This software is licensed under the terms of the Apache Licence Version 2.0
# which can be obtained at http://www.apache.org/licenses/LICENSE-2.0.
# In applying this licence, ECMWF does not waive the privileges and immunities
# granted to it by virtue of its status as an intergovernmental organisation nor
# does it submit to any jurisdiction.

# - Try to find SCIN
# Once done this will define
#  SCIN_FOUND - System has SCIN
#  SCIN_INCLUDE_DIRS - The SCIN include directories
#  SCIN_LIBRARIES - The libraries needed to use SCIN
#  SCIN_DEFINITIONS - Compiler switches required for using SCIN

option( WITH_SCIN "try to find scin installation" ON )

# skip if SCIN is already found or if has is built inside

if( NOT SCIN_FOUND AND WITH_SCIN )

    if( NOT DEFINED SCIN_PATH AND NOT "$ENV{SCIN_PATH}" STREQUAL "" )
        list( APPEND SCIN_PATH "$ENV{SCIN_PATH}" )
    endif()

    if( DEFINED SCIN_PATH )
        find_path(SCIN_INCLUDE_DIR NAMES scin_api.h PATHS ${SCIN_PATH} ${SCIN_PATH}/include PATH_SUFFIXES scin_api  NO_DEFAULT_PATH )
        find_library(SCIN_LIBRARY  NAMES scin       PATHS ${SCIN_PATH} ${SCIN_PATH}/lib     PATH_SUFFIXES scin      NO_DEFAULT_PATH )
    endif()
    
    find_path(SCIN_INCLUDE_DIR NAMES scin_api.h PATH_SUFFIXES scin_api )
    find_library( SCIN_LIBRARY NAMES scin       PATH_SUFFIXES scin     )
    
    include(FindPackageHandleStandardArgs)
    
    # handle the QUIETLY and REQUIRED arguments and set SCIN_FOUND to TRUE
    # if all listed variables are TRUE
    find_package_handle_standard_args(Scin  DEFAULT_MSG
                                      SCIN_LIBRARY SCIN_INCLUDE_DIR)

    if( SCIN_FOUND )
        set( SCIN_LIBRARIES    ${SCIN_LIBRARY} )
        set( SCIN_INCLUDE_DIRS ${SCIN_INCLUDE_DIR} )
    endif()
    
    mark_as_advanced(SCIN_INCLUDE_DIR SCIN_LIBRARY )
    
endif()
