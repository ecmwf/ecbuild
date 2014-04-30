# (C) Copyright 1996-2014 ECMWF.
#
# This software is licensed under the terms of the Apache Licence Version 2.0
# which can be obtained at http://www.apache.org/licenses/LICENSE-2.0.
# In applying this licence, ECMWF does not waive the privileges and immunities
# granted to it by virtue of its status as an intergovernmental organisation nor
# does it submit to any jurisdiction.

# - Try to find ECREGRID
# Once done this will define
#  ECREGRID_FOUND - System has ECREGRID
#  ECREGRID_INCLUDE_DIRS - The ECREGRID include directories
#  ECREGRID_LIBRARIES - The libraries needed to use ECREGRID
#  ECREGRID_DEFINITIONS - Compiler switches required for using ECREGRID

option( WITH_ECREGRID "try to find scin installation" ON )

# skip if ECREGRID is already found or if has is built inside

if( NOT ECREGRID_FOUND AND WITH_ECREGRID )

    if( NOT DEFINED ECREGRID_PATH AND NOT "$ENV{ECREGRID_PATH}" STREQUAL "" )
        list( APPEND ECREGRID_PATH "$ENV{ECREGRID_PATH}" )
    endif()

    if( DEFINED ECREGRID_PATH )
        find_path(ECREGRID_INCLUDE_DIR NAMES scin_api.h PATHS ${ECREGRID_PATH} ${ECREGRID_PATH}/include PATH_SUFFIXES scin_api  NO_DEFAULT_PATH )
        find_library(ECREGRID_LIBRARY  NAMES scin       PATHS ${ECREGRID_PATH} ${ECREGRID_PATH}/lib     PATH_SUFFIXES scin      NO_DEFAULT_PATH )
    endif()
    
    find_path(ECREGRID_INCLUDE_DIR NAMES scin_api.h PATH_SUFFIXES scin_api )
    find_library( ECREGRID_LIBRARY NAMES scin       PATH_SUFFIXES scin     )
    
    include(FindPackageHandleStandardArgs)
    
    # handle the QUIETLY and REQUIRED arguments and set ECREGRID_FOUND to TRUE
    # if all listed variables are TRUE
    find_package_handle_standard_args(Scin  DEFAULT_MSG
                                      ECREGRID_LIBRARY ECREGRID_INCLUDE_DIR)

    if( ECREGRID_FOUND )
        set( ECREGRID_LIBRARIES    ${ECREGRID_LIBRARY} )
        set( ECREGRID_INCLUDE_DIRS ${ECREGRID_INCLUDE_DIR} )
    endif()
    
    mark_as_advanced(ECREGRID_INCLUDE_DIR ECREGRID_LIBRARY )
    
endif()
