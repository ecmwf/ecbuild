# (C) Copyright 1996-2012 ECMWF.
# 
# This software is licensed under the terms of the Apache Licence Version 2.0
# which can be obtained at http://www.apache.org/licenses/LICENSE-2.0. 
# In applying this licence, ECMWF does not waive the privileges and immunities 
# granted to it by virtue of its status as an intergovernmental organisation nor
# does it submit to any jurisdiction.

# Try to find NetCDF
# Input:
#  * NETCDF_PATH - user defined path where to search for the library first
#  * NETCDF_CXX  - if to search also for netcdf_c++ wrapper library
# Once done this will define
#  NETCDF_FOUND - System has NetCDF
#  NETCDF_INCLUDE_DIRS - The NetCDF include directories
#  NETCDF_LIBRARIES - The libraries needed to use NetCDF

if( DEFINED NETCDF_PATH )
    find_path(NETCDF_INCLUDE_DIR netcdf.h       PATHS ${NETCDF_PATH}/include PATH_SUFFIXES netcdf NO_DEFAULT_PATH)
    find_library(NETCDF_LIBRARY  netcdf         PATHS ${NETCDF_PATH}/lib     PATH_SUFFIXES netcdf NO_DEFAULT_PATH)
endif()

set( _ncdf_sfx   netcdf netcdf4 )

find_path( NETCDF_INCLUDE_DIR netcdf.h PATH_SUFFIXES ${_ncdf_sfx} )

find_library( NETCDF_LIBRARY netcdf   PATH_SUFFIXES ${_ncdf_sfx} )

set( NETCDF_LIBRARIES    ${NETCDF_LIBRARY} )
set( NETCDF_INCLUDE_DIRS ${NETCDF_INCLUDE_DIR} )

include(FindPackageHandleStandardArgs)

if( NETCDF_CXX )

    set( _ncdf_cxx netcdf_c++ netcdf_c++ )

    find_library( NETCDF_CXX_LIBRARY NAMES ${_ncdf_cxx} PATHS ${NETCDF_PATH}/lib PATH_SUFFIXES ${_ncdf_sfx} NO_DEFAULT_PATH )
    find_library( NETCDF_CXX_LIBRARY NAMES ${_ncdf_cxx} netcdf_c++4 PATH_SUFFIXES ${_ncdf_sfx} )

    list( APPEND NETCDF_LIBRARIES    ${NETCDF_CXX_LIBRARY} )

    find_package_handle_standard_args( NETCDF  DEFAULT_MSG NETCDF_LIBRARY NETCDF_CXX_LIBRARY NETCDF_INCLUDE_DIR)

    mark_as_advanced(NETCDF_INCLUDE_DIR NETCDF_CXX_LIBRARY )

else()

    find_package_handle_standard_args( NETCDF  DEFAULT_MSG NETCDF_LIBRARY NETCDF_INCLUDE_DIR)

endif()

mark_as_advanced(NETCDF_INCLUDE_DIR NETCDF_LIBRARY )
