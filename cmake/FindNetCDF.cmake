# (C) Copyright 1996-2012 ECMWF.
# 
# This software is licensed under the terms of the Apache Licence Version 2.0
# which can be obtained at http://www.apache.org/licenses/LICENSE-2.0. 
# In applying this licence, ECMWF does not waive the privileges and immunities 
# granted to it by virtue of its status as an intergovernmental organisation nor
# does it submit to any jurisdiction.

# Try to find NetCDF3 or NetCDF4 -- default is 4
#
# Input:
#  * NETCDF_PATH - user defined path where to search for the library first
#  * NETCDF_CXX  - if to search also for netcdf_c++ wrapper library
#
# Output:
#  NETCDF_FOUND - System has NetCDF
#  NETCDF_DEFINITIONS
#  NETCDF_INCLUDE_DIRS - The NetCDF include directories
#  NETCDF_LIBRARIES - The libraries needed to use NetCDF

# default is netcdf4

if( NOT PREFER_NETCDF3 )
  set( PREFER_NETCDF4 1 )
else()
  set( PREFER_NETCDF4 0 )
endif()
mark_as_advanced( PREFER_NETCDF4 PREFER_NETCDF3 )

### NetCDF4

if( PREFER_NETCDF4 )

    if( DEFINED $ENV{NETCDF_PATH} )
        set( NETCDF_ROOT "$ENV{NETCDF_PATH}" )
        list( APPEND CMAKE_PREFIX_PATH  $ENV{NETCDF_PATH} )
    endif()

    if( DEFINED NETCDF_PATH )
        set( NETCDF_ROOT "${NETCDF_PATH}" )
        list( APPEND CMAKE_PREFIX_PATH  ${NETCDF_PATH} )
    endif()

    ecbuild_add_extra_search_paths( hdf5 )

    find_package( HDF5 COMPONENTS C CXX HL )

    ecbuild_add_extra_search_paths( netcdf4 )

    find_package( NetCDF4 )

    if( NETCDF_FOUND AND HDF5_FOUND )
        list( APPEND NETCDF_DEFINITIONS  ${HDF5_DEFINITIONS} )
        list( APPEND NETCDF_LIBRARIES    ${HDF5_HL_LIBRARIES} ${HDF5_LIBRARIES}  )
        list( APPEND  ${HDF5_INCLUDE_DIRS} )
    endif()

endif()

### NetCDF3

if( PREFER_NETCDF3 )

    find_package( NetCDF3 )

endif()
