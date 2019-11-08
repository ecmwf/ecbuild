# (C) Copyright 2011- ECMWF.
#
# This software is licensed under the terms of the Apache Licence Version 2.0
# which can be obtained at http://www.apache.org/licenses/LICENSE-2.0.
# In applying this licence, ECMWF does not waive the privileges and immunities
# granted to it by virtue of its status as an intergovernmental organisation nor
# does it submit to any jurisdiction.

# Try to find NetCDF includes and library, only shared libraries are supported!
#
# This module defines
#
#   - NetCDF_FOUND                - System has NetCDF
#   - NetCDF_INCLUDE_DIRS         - the NetCDF include directories
#   - NetCDF_LIBRARIES            - the libraries needed to use NetCDF
#   - NetCDF_VERSION              - the version of NetCDF
#
# Following components are available:
#
#   - C                           - C interface to NetCDF          (netcdf)
#   - CXX                         - CXX4 interface to NetCDF       (netcdf_c++4)
#   - Fortran                     - Fortran interface to NetCDF    (netcdff)
#   - CXX_LEGACY                  - Legacy C++ interface to NetCDF (netcdf_c++)
#
# For each component the following are defined:
#
#   - NetCDF_<comp>_FOUND         - whether the component is found
#   - NetCDF_<comp>_LIBRARIES     - the libraries for the component
#   - NetCDF_<comp>_INCLUDE_DIRS  - the include directories for specfied component
#   - NetCDF::NetCDF_<comp>       - target of component to be used with target_link_libraries()
#
# The following paths will be searched in order if set in CMake (first priority) or environment (second priority)
#
#   - NETCDF_ROOT                 - root of NetCDF installation
#   - NETCDF_DIR                  - root of NetCDF installation
#   - NETCDF_PATH                 - root of NetCDF installation
#   - NETCDF4_DIR                 - root of NetCDF installation
#   - NetCDF_ROOT                 - root of NetCDF installation
#   - NetCDF_DIR                  - root of NetCDF installation
#   - NetCDF_PATH                 - root of NetCDF installation
#   - NetCDF4_DIR                 - root of NetCDF installation
#
# Notes:
#
#   - Each variable is also available in fully uppercased version
#   - In each variable (not in targets), the "NetCDF" prefix may be interchanged with
#        * NetCDF4
#        * NETCDF
#        * NETCDF4
#        * The part "<xxx>" in current filename Find<xxx>.cmake
#   - Capitalisation of COMPONENT arguments does not matter: The <comp> part of variables will be defined with
#        * capitalisation as defined above
#        * Uppercase capitalisation
#        * capitalisation as used in find_package() arguments
#   - If no components are defined, all components will be searched without guarantee that the required component is available.
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

set( NETCDF_FIND_REQUIRED   ${NetCDF_FIND_REQUIRED} )
set( NETCDF_FIND_QUIETLY    ${NetCDF_FIND_QUIETLY} )
set( NETCDF_FIND_COMPONENTS ${NetCDF_FIND_COMPONENTS} )

list( APPEND NETCDF_FIND_COMPONENTS C )

if( NETCDF_CXX )
  ecbuild_debug( "FindNetCDF: also looking for C++ libraries" )
  list( APPEND NETCDF_FIND_COMPONENTS CXX )
endif()

if( NETCDF_Fortran OR NETCDF_FORTRAN OR NETCDF_F90 )
  ecbuild_debug( "FindNetCDF: also looking for Fortran libraries" )
  list( APPEND NETCDF_FIND_COMPONENTS FORTRAN F90 )
endif()

list(FIND NETCDF_FIND_COMPONENTS "FORTRAN" _index)
if(${_index} GREATER -1)
  list( APPEND NETCDF_FIND_COMPONENTS F90 )
endif()

list (FIND NETCDF_FIND_COMPONENTS "F90" _index)
if(${_index} GREATER -1)
  list( APPEND NETCDF_FIND_COMPONENTS FORTRAN )
endif()

list(FIND NETCDF_FIND_COMPONENTS "Fortran" _index)
if(${_index} GREATER -1)
  list( REMOVE_ITEM NETCDF_FIND_COMPONENTS Fortran )
  list( APPEND NETCDF_FIND_COMPONENTS FORTRAN F90 )
endif()

list( REMOVE_DUPLICATES NETCDF_FIND_COMPONENTS )
ecbuild_debug( "FindNetCDF: looking for components ${NETCDF_FIND_COMPONENTS}" )

### NetCDF4

if( PREFER_NETCDF4 )

  ecbuild_debug( "FindNetCDF: looking for NetCDF4" )

  # CONFIGURE the NETCDF_FIND_COMPONENTS variable

  # Find NetCDF4

  # message( "NETCDF CMAKE_PREFIX_PATH = [${CMAKE_PREFIX_PATH}]")
  # ecbuild_debug_var( NETCDF_ROOT )
  # ecbuild_debug_var( NETCDF_FIND_COMPONENTS )
  # ecbuild_debug_var( NETCDF_FIND_QUIETLY )
  # ecbuild_debug_var( NETCDF_FIND_REQUIRED )
  find_package( NetCDF4 COMPONENTS ${NETCDF_FIND_COMPONENTS} )
  # ecbuild_debug_var( NETCDF4_FOUND )
  # ecbuild_debug_var( NETCDF_FOUND )
  # ecbuild_debug_var( NETCDF_LIBRARIES )
  # ecbuild_debug_var( NETCDF_INCLUDE_DIRS )

  list( APPEND NETCDF_Fortran_LIBRARIES ${NETCDF_FORTRAN_LIBRARIES} ${NETCDF_F90_LIBRARIES} )
  if( NETCDF_Fortran_LIBRARIES )
    list( REMOVE_DUPLICATES NETCDF_Fortran_LIBRARIES )
  endif()

  # ecbuild_debug_var( NETCDF_Fortran_LIBRARIES )
  # ecbuild_debug_var( NETCDF_C_LIBRARIES )
  # ecbuild_debug_var( NETCDF_CXX_LIBRARIES )


  set_package_properties( NetCDF4 PROPERTIES TYPE RECOMMENDED PURPOSE "support for NetCDF4 file format" )

  #ecbuild_debug_var( NETCDF_FOUND )
  #ecbuild_debug_var( NETCDF_LIBRARIES )
  #ecbuild_debug_var( NETCDF_INCLUDE_DIRS )

endif()

## Search hints for finding include directories and libraries
set( _search_hints
              ${NETCDF_ROOT} ${NETCDF_DIR} ${NETCDF_PATH} ${NETCDF4_DIR}
              ${NetCDF_ROOT} ${NetCDF_DIR} ${NetCDF_PATH} ${NetCDF4_DIR}
              ENV NETCDF_ROOT ENV NETCDF_DIR ENV NETCDF_PATH ENV NETCDF4_DIR
              ENV NetCDF_ROOT ENV NetCDF_DIR ENV NetCDF_PATH ENV NetCDF4_DIR
 )

## Find include directories
find_path(NetCDF_INCLUDE_DIRS
  NAMES netcdf.h
  DOC "netcdf include directories"
  HINTS ${_search_hints}
  PATH_SUFFIXES include ../../include
)
mark_as_advanced(NetCDF_INCLUDE_DIRS)

## Find libraries for each component
foreach( _comp ${_search_components} )
  string( TOUPPER "${_comp}" _COMP )

  find_library(NetCDF_${_comp}_LIBRARY
    NAMES ${NetCDF_${_comp}_LIBRARY_NAME}
    DOC "netcdf ${_comp} library"
    HINTS ${_search_hints}
    PATH_SUFFIXES lib ../../lib
  )
  mark_as_advanced(NetCDF_${_comp}_LIBRARY)
  if( NetCDF_${_comp}_LIBRARY AND NOT (NetCDF_${_comp}_LIBRARY MATCHES ".a$") )
    set( NetCDF_${_comp}_LIBRARY_SHARED TRUE )
  endif()
  if( NetCDF_${_comp}_LIBRARY_SHARED AND NetCDF_INCLUDE_DIRS )
    set( ${CMAKE_FIND_PACKAGE_NAME}_${_arg_${_COMP}}_FOUND TRUE )
    list( APPEND NetCDF_LIBRARIES ${NetCDF_${_comp}_LIBRARY} )      
    list( APPEND NetCDF_${_comp}_LIBRARIES ${NetCDF_${_comp}_LIBRARY} )

    if (NOT TARGET NetCDF::NetCDF_${_comp})
      add_library(NetCDF::NetCDF_${_comp} UNKNOWN IMPORTED)
      set_target_properties(NetCDF::NetCDF_${_comp} PROPERTIES
        IMPORTED_LOCATION "${NetCDF_${_comp}_LIBRARY}"
        INTERFACE_INCLUDE_DIRECTORIES "${NetCDF_INCLUDE_DIRS}")
    endif()
  endif()
endforeach()

## Find version
if (NetCDF_INCLUDE_DIRS)
  find_program( NETCDF_CONFIG_EXECUTABLE
      NAMES nc-config
      HINTS ${_search_hints}
      PATH_SUFFIXES bin Bin ../../bin
      DOC "NetCDF nc-config helper" )
  mark_as_advanced( NETCDF_CONFIG_EXECUTABLE )

  if( NETCDF_CONFIG_EXECUTABLE )
    execute_process( COMMAND ${NETCDF_CONFIG_EXECUTABLE} --version
      RESULT_VARIABLE _netcdf_config_result
      OUTPUT_VARIABLE _netcdf_config_version)

    if( _netcdf_config_result EQUAL 0 )
      string(REGEX REPLACE ".* ((([0-9]+)\\.)+([0-9]+)).*" "\\1" NetCDF_VERSION "${_netcdf_config_version}" )
    endif()

  elseif( EXISTS "${NetCDF_INCLUDE_DIRS}/netcdf_meta.h" )

    file(STRINGS "${NetCDF_INCLUDE_DIRS}/netcdf_meta.h" _netcdf_version_lines
      REGEX "#define[ \t]+NC_VERSION_(MAJOR|MINOR|PATCH|NOTE)")
    string(REGEX REPLACE ".*NC_VERSION_MAJOR *\([0-9]*\).*" "\\1" _netcdf_version_major "${_netcdf_version_lines}")
    string(REGEX REPLACE ".*NC_VERSION_MINOR *\([0-9]*\).*" "\\1" _netcdf_version_minor "${_netcdf_version_lines}")
    string(REGEX REPLACE ".*NC_VERSION_PATCH *\([0-9]*\).*" "\\1" _netcdf_version_patch "${_netcdf_version_lines}")
    string(REGEX REPLACE ".*NC_VERSION_NOTE *\"\([^\"]*\)\".*" "\\1" _netcdf_version_note "${_netcdf_version_lines}")
    set(NetCDF_VERSION "${_netcdf_version_major}.${_netcdf_version_minor}.${_netcdf_version_patch}${_netcdf_version_note}")
    unset(_netcdf_version_major)
    unset(_netcdf_version_minor)
    unset(_netcdf_version_patch)
    unset(_netcdf_version_note)
    unset(_netcdf_version_lines)
  endif()
endif ()

## Finalize find_package
include(FindPackageHandleStandardArgs)

find_package_handle_standard_args( ${CMAKE_FIND_PACKAGE_NAME}
  REQUIRED_VARS NetCDF_INCLUDE_DIRS NetCDF_LIBRARIES
  VERSION_VAR NetCDF_VERSION
  HANDLE_COMPONENTS )

if( ${CMAKE_FIND_PACKAGE_NAME}_FOUND AND NOT ${CMAKE_FIND_PACKAGE_NAME}_FIND_QUIETLY )
  message( STATUS "Find${CMAKE_FIND_PACKAGE_NAME} defines targets:" )
  foreach( _comp ${_search_components} )
    string( TOUPPER "${_comp}" _COMP )

    if( ${CMAKE_FIND_PACKAGE_NAME}_${_arg_${_COMP}}_FOUND )
      message( STATUS "  - NetCDF::NetCDF_${_comp} [${NetCDF_${_comp}_LIBRARY}]")
    endif()
  endforeach()
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
