# (C) Copyright 1996-2012 ECMWF.
#
# This software is licensed under the terms of the Apache Licence Version 2.0
# which can be obtained at http://www.apache.org/licenses/LICENSE-2.0.
# In applying this licence, ECMWF does not waive the privileges and immunities
# granted to it by virtue of its status as an intergovernmental organisation nor
# does it submit to any jurisdiction.

# - Try to find EcLib
# Once done this will define
#  ECLIB_FOUND - System has ECLIB
#  ECLIB_INCLUDE_DIRS - The ECLIB include directories
#  ECLIB_LIBRARIES - The libraries needed to use ECLIB

# skip if ECLIB is already found or if has is built inside

if( NOT ECLIB_FOUND )

    # find external eclib

    set( _ENV_ECLIB_PATH "$ENV{ECLIB_PATH}" )
    if( NOT DEFINED ECLIB_PATH AND _ENV_ECLIB_PATH )
        set( ECLIB_PATH ${_ENV_ECLIB_PATH} )
    endif()

    if( DEFINED ECLIB_PATH )
        find_path(ECLIB_INCLUDE_DIR NAMES eclib_version.h PATHS ${ECLIB_PATH} ${ECLIB_PATH}/include PATH_SUFFIXES eclib  NO_DEFAULT_PATH)
        find_library(ECLIB_LIBRARY  NAMES Ec              PATHS ${ECLIB_PATH} ${ECLIB_PATH}/lib     PATH_SUFFIXES eclib  NO_DEFAULT_PATH)
    endif()
    
    find_path(ECLIB_INCLUDE_DIR NAMES eclib_version.h PATH_SUFFIXES eclib )
    find_library( ECLIB_LIBRARY NAMES Ec              PATH_SUFFIXES eclib )

    include(FindPackageHandleStandardArgs)
    
    # handle the QUIETLY and REQUIRED arguments and set ECLIB_FOUND to TRUE
    # if all listed variables are TRUE
    find_package_handle_standard_args(ECLIB  DEFAULT_MSG
                                      ECLIB_LIBRARY ECLIB_INCLUDE_DIR )
    
    mark_as_advanced(ECLIB_INCLUDE_DIR ECLIB_LIBRARY )

    set( ECLIB_LIBRARIES    ${ECLIB_LIBRARY} )
    set( ECLIB_INCLUDE_DIRS ${ECLIB_INCLUDE_DIR} )

    debug_var( ECLIB_LIBRARIES )
    debug_var( ECLIB_INCLUDE_DIRS )

endif()
