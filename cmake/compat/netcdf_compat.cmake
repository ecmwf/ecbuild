# (C) Copyright 2020- ECMWF.
#
# This software is licensed under the terms of the Apache Licence Version 2.0
# which can be obtained at http://www.apache.org/licenses/LICENSE-2.0.
# In applying this licence, ECMWF does not waive the privileges and immunities
# granted to it by virtue of its status as an intergovernmental organisation nor
# does it submit to any jurisdiction.

# Extra exports for FindNetCDF.cmake for backwards compatibility
#
# This module defines
#
#   - NetCDF_INCLUDE_DIRS         - the NetCDF include directories
#   - NetCDF_LIBRARIES            - the libraries needed to use NetCDF
#
# For each component the following are defined:
#
#   - NetCDF_<comp>_LIBRARIES     - the libraries for the component
#   - NetCDF_<comp>_INCLUDE_DIRS  - the include directories for specfied component
#
# Notes:
#
#   - Capitalisation of COMPONENT arguments does not matter: The <comp> part of variables will be defined with
#        * capitalisation as defined above
#        * Uppercase capitalisation
#        * capitalisation as used in find_package() arguments
#   - Each variable is also available in fully uppercased version
#   - In each variable (not in targets), the "NetCDF" prefix may be interchanged with
#        * NetCDF4
#        * NETCDF
#        * NETCDF4
#        * The part "<xxx>" in current filename Find<xxx>.cmake

set(__args)
foreach( _comp ${_search_components} )
  string( TOUPPER "${_comp}" _COMP )
  list(APPEND __args ${_arg_${_COMP}} )
endforeach()

foreach( _comp ${_search_components} )
  if( NetCDF_${_comp}_FOUND )
    list( APPEND NetCDF_INCLUDE_DIRS ${NetCDF_${_comp}_INCLUDE_DIR} )
    list( APPEND NetCDF_${_comp}_INCLUDE_DIRS ${NetCDF_${_comp}_INCLUDE_DIR} )
    list( APPEND NetCDF_${_comp}_LIBRARIES ${NetCDF_${_comp}_LIBRARY} )
    if( DEFINED NetCDF_${_comp}_EXTRA_LIBRARIES )
      list( APPEND NetCDF_${_comp}_LIBRARIES ${NetCDF_${_comp}_EXTRA_LIBRARIES})
    endif()
    list( APPEND NetCDF_LIBRARIES ${NetCDF_${_comp}_LIBRARIES} )
  endif()
endforeach()
if( NetCDF_INCLUDE_DIRS )
  list( REMOVE_DUPLICATES NetCDF_INCLUDE_DIRS )
endif()

foreach( _prefix NetCDF NetCDF4 NETCDF NETCDF4 ${CMAKE_FIND_PACKAGE_NAME} )
  set( ${_prefix}_INCLUDE_DIRS ${NetCDF_INCLUDE_DIRS} )
  set( ${_prefix}_LIBRARIES    ${NetCDF_LIBRARIES})
  set( ${_prefix}_VERSION      ${NetCDF_VERSION} )
  set( ${_prefix}_FOUND        ${${CMAKE_FIND_PACKAGE_NAME}_FOUND} )

  foreach( _comp ${_search_components} )
    string( TOUPPER "${_comp}" _COMP )
    set( _arg_comp ${_arg_${_COMP}} )
    set( ${_prefix}_${_comp}_FOUND     ${${CMAKE_FIND_PACKAGE_NAME}_${_arg_comp}_FOUND} )
    set( ${_prefix}_${_COMP}_FOUND     ${${CMAKE_FIND_PACKAGE_NAME}_${_arg_comp}_FOUND} )
    set( ${_prefix}_${_arg_comp}_FOUND ${${CMAKE_FIND_PACKAGE_NAME}_${_arg_comp}_FOUND} )

    set( ${_prefix}_${_comp}_LIBRARIES     ${NetCDF_${_comp}_LIBRARIES} )
    set( ${_prefix}_${_COMP}_LIBRARIES     ${NetCDF_${_comp}_LIBRARIES} )
    set( ${_prefix}_${_arg_comp}_LIBRARIES ${NetCDF_${_comp}_LIBRARIES} )

    set( ${_prefix}_${_comp}_INCLUDE_DIRS     ${NetCDF_INCLUDE_DIRS} )
    set( ${_prefix}_${_COMP}_INCLUDE_DIRS     ${NetCDF_INCLUDE_DIRS} )
    set( ${_prefix}_${_arg_comp}_INCLUDE_DIRS ${NetCDF_INCLUDE_DIRS} )
  endforeach()
endforeach()
