# (C) Copyright 2019- ECMWF.
#
# This software is licensed under the terms of the Apache Licence Version 2.0
# which can be obtained at http://www.apache.org/licenses/LICENSE-2.0.
# In applying this licence, ECMWF does not waive the privileges and immunities
# granted to it by virtue of its status as an intergovernmental organisation nor
# does it submit to any jurisdiction.

##############################################################################
#.rst:
#
# ecbuild_compat_setversion
# ======================
#
# Read a VERSION.cmake file and set the project variables.
#
#   ecbuild_compat_setversion()
#
# Output variables
# ----------------
#
# * <pname>_VERSION_MAJOR
# * <pname>_VERSION_MINOR
# * <pname>_VERSION_PATCH
# * <pname>_VERSION
# * <pname>_VERSION_STR
#
##############################################################################

macro(ecbuild_compat_setversion)
  # read and parse project version file
  if( EXISTS ${PROJECT_SOURCE_DIR}/VERSION.cmake )
    include( ${PROJECT_SOURCE_DIR}/VERSION.cmake )
    set( __version ${${PROJECT_NAME}_VERSION_STR} )
  else()
    set( __version "0.0.0" )
  endif()

  # Remove any non-numbers
  string( REGEX REPLACE "^((([0-9]+)\\.)+([0-9]+)).*" "\\1" __version "${__version}" )

  string( REPLACE "." " " _version_list "${__version}" ) # dots to spaces

  separate_arguments( _version_list )
  list( LENGTH _version_list _len )
  set( __version "" )
  if( ${_len} GREATER 0 )
    list( GET _version_list 0 ${PROJECT_NAME}_VERSION_MAJOR )
    set( __version "${${PROJECT_NAME}_VERSION_MAJOR}" )
  endif()
  if( ${_len} GREATER 1 )
    list( GET _version_list 1 ${PROJECT_NAME}_VERSION_MINOR )
    set( __version "${__version}.${${PROJECT_NAME}_VERSION_MINOR}" )
  endif()
  if( ${_len} GREATER 2 )
    list( GET _version_list 2 ${PROJECT_NAME}_VERSION_PATCH )
    set( __version "${__version}.${${PROJECT_NAME}_VERSION_PATCH}" )
  endif()
  if( ${_len} GREATER 3 )
    list( GET _version_list 3 ${PROJECT_NAME}_VERSION_TWEAK )
    set( __version "${__version}.${${PROJECT_NAME}_VERSION_TWEAK}" )
  endif()

  set( ${PROJECT_NAME}_VERSION "${__version}")
  set( ${PROJECT_NAME}_VERSION "${${PROJECT_NAME}_VERSION}" CACHE INTERNAL "package ${PROJECT_NAME} version" )
  set( ${PROJECT_NAME}_VERSION_STR "${${PROJECT_NAME}_VERSION}" CACHE INTERNAL "package ${PROJECT_NAME} version" )
endmacro()
