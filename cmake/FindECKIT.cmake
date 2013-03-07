# (C) Copyright 1996-2012 ECMWF.
#
# This software is licensed under the terms of the Apache Licence Version 2.0
# which can be obtained at http://www.apache.org/licenses/LICENSE-2.0.
# In applying this licence, ECMWF does not waive the privileges and immunities
# granted to it by virtue of its status as an intergovernmental organisation nor
# does it submit to any jurisdiction.

# - Try to find eckit
# Once done this will define
#  ECKIT_FOUND - System has ECKIT
#  ECKIT_INCLUDE_DIRS - The ECKIT include directories
#  ECKIT_LIBRARIES - The libraries needed to use ECKIT

# skip if ECKIT is already found or if has is built inside

if( NOT ECKIT_FOUND )

    # find external eckit

    set( _ENV_ECKIT_PATH "$ENV{ECKIT_PATH}" )
    if( NOT DEFINED ECKIT_PATH AND _ENV_ECKIT_PATH )
        set( ECKIT_PATH ${_ENV_ECKIT_PATH} )
    endif()

    if( DEFINED ECKIT_PATH )
        find_path(ECKIT_INCLUDE_DIR NAMES eckit_version.h PATHS ${ECKIT_PATH} ${ECKIT_PATH}/include PATH_SUFFIXES eckit  NO_DEFAULT_PATH)
        find_library(ECKIT_LIBRARY  NAMES Ec              PATHS ${ECKIT_PATH} ${ECKIT_PATH}/lib     PATH_SUFFIXES eckit  NO_DEFAULT_PATH)
    endif()
    
    find_path(ECKIT_INCLUDE_DIR NAMES eckit_version.h PATH_SUFFIXES eckit )
    find_library( ECKIT_LIBRARY NAMES Ec              PATH_SUFFIXES eckit )

    include(FindPackageHandleStandardArgs)
    
    # handle the QUIETLY and REQUIRED arguments and set ECKIT_FOUND to TRUE
    # if all listed variables are TRUE
    find_package_handle_standard_args(ECKIT DEFAULT_MSG
                                      ECKIT_LIBRARY ECKIT_INCLUDE_DIR )
    
    mark_as_advanced(ECKIT_INCLUDE_DIR ECKIT_LIBRARY )

    set( ECKIT_LIBRARIES    ${ECKIT_LIBRARY} )
    set( ECKIT_INCLUDE_DIRS ${ECKIT_INCLUDE_DIR} )

    debug_var( ECKIT_LIBRARIES )
    debug_var( ECKIT_INCLUDE_DIRS )

endif()
