# (C) Copyright 1996-2012 ECMWF.
# 
# This software is licensed under the terms of the Apache Licence Version 2.0
# which can be obtained at http://www.apache.org/licenses/LICENSE-2.0. 
# In applying this licence, ECMWF does not waive the privileges and immunities 
# granted to it by virtue of its status as an intergovernmental organisation nor
# does it submit to any jurisdiction.

# Try to find NetCDF
#
# Input:
#  * NETCDF_PATH - user defined path where to search for the library first
#  * NETCDF_CXX  - if to search also for netcdf_c++ wrapper library
#
# Output:
#  NETCDF_FOUND - System has NetCDF
#  NETCDF_INCLUDE_DIRS - The NetCDF include directories
#  NETCDF_LIBRARIES - The libraries needed to use NetCDF

### TODO: generalize this into a macro for all ecbuild

if( DEFINED NETCDF_PATH )
    list( APPEND _netcdf_incs ${NETCDF_PATH} ${NETCDF_PATH}/include )
    list( APPEND _netcdf_libs ${NETCDF_PATH} ${NETCDF_PATH}/lib )
endif()
	
foreach( _h /usr/local/apps/netcdf )

	if( EXISTS ${_h} )
	
        list( APPEND _netcdf_incs  ${_h}/include ${_h}/current/include ${_h}/new/include ${_h}/stable/include )
        list( APPEND _netcdf_libs  ${_h}/lib ${_h}/current/lib ${_h}/new/lib ${_h}/stable/lib )

		file(GLOB _hd ${_h}/*)
        foreach( d ${_hd} )
            if( IS_DIRECTORY ${d} )
                list( APPEND _netcdf_incs ${d}/include ${d}/LP64/include )
                list( APPEND _netcdf_libs ${d}/lib ${d}/LP64/lib )
            endif()
        endforeach()
    endif()

endforeach() 

###

set( _ncdf_sfx netcdf LP64 )

find_path( NETCDF_INCLUDE_DIR  netcdf.h  PATHS ${_netcdf_incs} PATH_SUFFIXES ${_ncdf_sfx} NO_DEFAULT_PATH )
find_path( NETCDF_INCLUDE_DIR  netcdf.h  PATHS ${_netcdf_incs} PATH_SUFFIXES ${_ncdf_sfx} )

find_library( NETCDF_LIBRARY  netcdf  PATHS ${_netcdf_libs} PATH_SUFFIXES ${_ncdf_sfx}  NO_DEFAULT_PATH )
find_library( NETCDF_LIBRARY  netcdf  PATHS ${_netcdf_libs} PATH_SUFFIXES ${_ncdf_sfx}  )

set( NETCDF_LIBRARIES    ${NETCDF_LIBRARY} )
set( NETCDF_INCLUDE_DIRS ${NETCDF_INCLUDE_DIR} )

include(FindPackageHandleStandardArgs)

if( NETCDF_CXX )

    find_path( NETCDF_CXX_INCLUDE_DIR netcdfcpp.h PATHS ${_netcdf_incs} PATH_SUFFIXES ${_ncdf_sfx} NO_DEFAULT_PATH)
    find_path( NETCDF_CXX_INCLUDE_DIR netcdfcpp.h PATHS ${_netcdf_incs} PATH_SUFFIXES ${_ncdf_sfx} )

    set( _ncdf_cxx netcdf_c++ netcdf_c++ netcdf_c++4 )

    find_library( NETCDF_CXX_LIBRARY NAMES ${_ncdf_cxx} PATHS ${_netcdf_libs} PATH_SUFFIXES ${_ncdf_sfx} NO_DEFAULT_PATH )
    find_library( NETCDF_CXX_LIBRARY NAMES ${_ncdf_cxx} PATHS ${_netcdf_libs} PATH_SUFFIXES ${_ncdf_sfx} )

    list( APPEND NETCDF_INCLUDE_DIRS ${NETCDF_CXX_INCLUDE_DIR} )
    list( APPEND NETCDF_LIBRARIES    ${NETCDF_CXX_LIBRARY} )

    find_package_handle_standard_args( NETCDF  DEFAULT_MSG NETCDF_LIBRARY NETCDF_CXX_LIBRARY NETCDF_INCLUDE_DIR NETCDF_CXX_INCLUDE_DIR )

    mark_as_advanced(NETCDF_INCLUDE_DIR NETCDF_CXX_LIBRARY )

else()

    find_package_handle_standard_args( NETCDF  DEFAULT_MSG NETCDF_LIBRARY NETCDF_INCLUDE_DIR)

endif()

mark_as_advanced(NETCDF_INCLUDE_DIR NETCDF_LIBRARY )
