# (C) Copyright 1996-2012 ECMWF.
#
# This software is licensed under the terms of the Apache Licence Version 2.0
# which can be obtained at http://www.apache.org/licenses/LICENSE-2.0.
# In applying this licence, ECMWF does not waive the privileges and immunities
# granted to it by virtue of its status as an intergovernmental organisation nor
# does it submit to any jurisdiction.

# - Try to find ODB_API
# Once done this will define
#  ODB_API_FOUND - System has ODB_API
#  ODB_API_INCLUDE_DIRS - The ODB_API include directories
#  ODB_API_LIBRARIES - The libraries needed to use ODB_API
#  ODB_API_DEFINITIONS - Compiler switches required for using ODB_API

# skip if ODB_API is already found or if has is built inside

if( NOT ODB_API_FOUND )

    # find external odb_api

    if( NOT DEFINED ODB_API_PATH AND DEFINED $ENV{ODB_API_PATH} )
        set( ODB_API_PATH $ENV{ODB_API_PATH} )
    endif()

    if( DEFINED ODB_API_PATH )
        find_path(ODB_API_INCLUDE_DIR NAMES oda.h PATHS ${ODB_API_PATH} ${ODB_API_PATH}/include PATH_SUFFIXES odb_api  NO_DEFAULT_PATH)
        find_library(ODB_API_LIBRARY  NAMES odb   PATHS ${ODB_API_PATH} ${ODB_API_PATH}/lib     PATH_SUFFIXES odb_api  NO_DEFAULT_PATH)
    endif()

    find_path(ODB_API_INCLUDE_DIR NAMES oda.h PATH_SUFFIXES odb_api )
    find_library( ODB_API_LIBRARY NAMES odb   PATH_SUFFIXES odb_api )

    set( ODB_API_LIBRARIES    ${ODB_API_LIBRARY} )
    set( ODB_API_INCLUDE_DIRS ${ODB_API_INCLUDE_DIR} )
    set( ODB_API_DEFINITIONS  "" )

    include(FindPackageHandleStandardArgs)

    find_package_handle_standard_args(ODB_API  DEFAULT_MSG
                                      ODB_API_LIBRARY ODB_API_INCLUDE_DIR)

    mark_as_advanced( ODB_API_INCLUDE_DIR ODB_API_LIBRARY )

endif()
