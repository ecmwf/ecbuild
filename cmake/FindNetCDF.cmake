# (C) Copyright 1996-2014 ECMWF.
# 
# This software is licensed under the terms of the Apache Licence Version 2.0
# which can be obtained at http://www.apache.org/licenses/LICENSE-2.0. 
# In applying this licence, ECMWF does not waive the privileges and immunities 
# granted to it by virtue of its status as an intergovernmental organisation nor
# does it submit to any jurisdiction.

# Try to find NetCDF3 or NetCDF4 -- default is 4
#
# find_package( NetCDF <version> COMPONENTS C CXX Fortran )
#
# Input:
#  * NETCDF_PATH    - user defined path where to search for the library first
#  * NETCDF_DIR     - user defined path where to search for the library first
#  * NETCDF_CXX     - if to search also for netcdf_c++ wrapper library
#  * NETCDF_Fortran - if to search also for netcdff wrapper library
#
# Output:
#  NETCDF_FOUND - System has NetCDF
#  NETCDF_DEFINITIONS
#  NETCDF_INCLUDE_DIRS - The NetCDF include directories
#  NETCDF_LIBRARIES - The libraries needed to use NetCDF

# default is netcdf4
if( NetCDF_FIND_VERSION STREQUAL "3" )
    set( PREFER_NETCDF3 1 )
endif()

if( NOT PREFER_NETCDF3 )
  set( PREFER_NETCDF4 1 )
else()
  set( PREFER_NETCDF4 0 )
endif()
mark_as_advanced( PREFER_NETCDF4 PREFER_NETCDF3 )

set( NETCDF_FIND_REQUIRED ${NetCDF_FIND_REQUIRED} )
set( NETCDF_FIND_QUIETLY  ${NetCDF_FIND_QUIETLY} )


### NetCDF4

if( PREFER_NETCDF4 )

    ## hdf5

    if( DEFINED ENV{HDF5_PATH} )
        message( "FindNetCDF.cmake DEBUG: ENV{HDF5_PATH} = $ENV{HDF5_PATH}")
        set( HDF5_ROOT "$ENV{HDF5_PATH}" )
        list( APPEND CMAKE_PREFIX_PATH  $ENV{HDF5_PATH} )
    endif()

    if( DEFINED ENV{HDF5_DIR} )
        message( "FindNetCDF.cmake DEBUG: ENV{HDF5_DIR} = $ENV{HDF5_DIR}")
        set( HDF5_ROOT "$ENV{HDF5_DIR}" )
        list( APPEND CMAKE_PREFIX_PATH  $ENV{HDF5_DIR} )
    endif()

    if( DEFINED HDF5_PATH )
        if( HDF5_PATH )
          debug_var( HDF5_PATH )
          set( HDF5_ROOT "${HDF5_PATH}" )
          list( APPEND CMAKE_PREFIX_PATH  ${HDF5_PATH} )
        endif()
    endif()

    if( DEFINED HDF5_DIR )
        if( HDF5_DIR )
            debug_var( HDF5_DIR )
            set( HDF5_ROOT "${HDF5_DIR}" )
            list( APPEND CMAKE_PREFIX_PATH  ${HDF5_DIR} )
        endif()
    endif()

    ecbuild_add_extra_search_paths( hdf5 )
    message( "HDF5 CMAKE_PREFIX_PATH = ${CMAKE_PREFIX_PATH}")

    find_package( HDF5 COMPONENTS C CXX Fortran HL Fortran_HL QUIET )

    ## netcdf4

    if( DEFINED ENV{NETCDF_PATH} )
        message( "FindNetCDF.cmake DEBUG: ENV{NETCDF_PATH} = $ENV{NETCDF_PATH}")
        set( NETCDF_ROOT "$ENV{NETCDF_PATH}" )
        list( APPEND CMAKE_PREFIX_PATH  $ENV{NETCDF_PATH} )
    endif()

    if( DEFINED ENV{NETCDF_DIR} )
        message( "FindNetCDF.cmake DEBUG: ENV{NETCDF_DIR} = $ENV{NETCDF_DIR}")
        set( NETCDF_ROOT "$ENV{NETCDF_DIR}" )
        list( APPEND CMAKE_PREFIX_PATH  $ENV{NETCDF_DIR} )
    endif()

    if( DEFINED NETCDF_PATH )
        debug_var( NETCDF_PATH )
        if( NETCDF_PATH )
            set( NETCDF_ROOT "${NETCDF_PATH}" )
            list( APPEND CMAKE_PREFIX_PATH  ${NETCDF_PATH} )
        endif()
    endif()

    if( DEFINED NETCDF_DIR )
        debug_var( NETCDF_DIR )
        if( NETCDF_DIR )
            set( NETCDF_ROOT "${NETCDF_DIR}" )
            list( APPEND CMAKE_PREFIX_PATH  ${NETCDF_DIR} )
        endif()
    endif()

    # CONFIGURE the NETCDF_FIND_COMPONENTS variable

    set( NETCDF_FIND_COMPONENTS ${NetCDF_FIND_COMPONENTS} )

    list( APPEND NETCDF_FIND_COMPONENTS C )
    if( NETCDF_CXX )
        list( APPEND NETCDF_FIND_COMPONENTS CXX )
    endif()
    if( NETCDF_Fortran OR NETCDF_FORTRAN OR NETCDF_F90 )
        list( APPEND NETCDF_FIND_COMPONENTS FORTRAN F90 )
    endif()

    list (FIND NETCDF_FIND_COMPONENTS "FORTRAN" _index)
    if (${_index} GREATER -1)
        list( APPEND NETCDF_FIND_COMPONENTS F90 )
    endif()

    list (FIND NETCDF_FIND_COMPONENTS "F90" _index)
    if (${_index} GREATER -1)
        list( APPEND NETCDF_FIND_COMPONENTS FORTRAN )
    endif()

    list (FIND NETCDF_FIND_COMPONENTS "Fortran" _index)
    if (${_index} GREATER -1)
        list( REMOVE_ITEM NETCDF_FIND_COMPONENTS Fortran )
        list( APPEND NETCDF_FIND_COMPONENTS FORTRAN F90 )
    endif()

    list( REMOVE_DUPLICATES NETCDF_FIND_COMPONENTS )

    # Find NetCDF4

    ecbuild_add_extra_search_paths( netcdf4 )
    ecbuild_add_extra_search_paths( netcdf ) # fallback to netcdf search paths

    message( "NETCDF CMAKE_PREFIX_PATH = ${CMAKE_PREFIX_PATH}")
    debug_var( NETCDF_ROOT )
    debug_var( NETCDF_FIND_COMPONENTS )
    debug_var( NETCDF_FIND_QUIETLY )
    debug_var( NETCDF_FIND_REQUIRED )
    find_package( NetCDF4 )

	set_package_properties( NetCDF4 PROPERTIES TYPE RECOMMENDED PURPOSE "support for NetCDF4 file format" )

    if( NETCDF_FOUND AND HDF5_FOUND )
        # list( APPEND NETCDF_DEFINITIONS  ${HDF5_DEFINITIONS} )
        list( APPEND NETCDF_LIBRARIES    ${HDF5_HL_LIBRARIES} ${HDF5_LIBRARIES}  )
        list( APPEND NETCDF_INCLUDE_DIRS ${HDF5_INCLUDE_DIRS} )
    endif()

    #debug_var( NETCDF_FOUND )
    #debug_var( NETCDF_LIBRARIES )
    #debug_var( NETCDF_INCLUDE_DIRS )
    #debug_var( HDF5_FOUND )
    #debug_var( HDF5_INCLUDE_DIRS )
    #debug_var( HDF5_HL_LIBRARIES )
    #debug_var( HDF5_LIBRARIES )

endif()

### NetCDF3

if( PREFER_NETCDF3 )

    message( "LOOKING FOR NETCDF3" )

    debug_var( NetCDF_FIND_COMPONENTS )
    debug_var( NetCDF_FIND_QUIETLY )
    debug_var( NetCDF_FIND_REQUIRED )

    list (FIND NetCDF_FIND_COMPONENTS "CXX" _index)
    if (${_index} GREATER -1)
        set( NETCDF_CXX 1 )
    endif()

    list (FIND NetCDF_FIND_COMPONENTS "Fortran" _index)
    if (${_index} GREATER -1)
        set( NETCDF_Fortran 1 )
    endif()

    list (FIND NetCDF_FIND_COMPONENTS "FORTRAN" _index)
    if (${_index} GREATER -1)
        set( NETCDF_Fortran 1 )
    endif()

    list (FIND NetCDF_FIND_COMPONENTS "F90" _index)
    if (${_index} GREATER -1)
        set( NETCDF_Fortran 1 )
    endif()

    ecbuild_add_extra_search_paths( netcdf3 )
    ecbuild_add_extra_search_paths( netcdf ) # fallback to netcdf search paths

    message( "NETCDF CMAKE_PREFIX_PATH = ${CMAKE_PREFIX_PATH}" )


    find_package( NetCDF3 )

	set_package_properties( NetCDF3 PROPERTIES TYPE RECOMMENDED PURPOSE "support for NetCDF3 file format" )

endif()
