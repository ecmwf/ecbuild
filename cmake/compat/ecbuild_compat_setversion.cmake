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

  string( REPLACE "." " " _version_list "${__version}" ) # dots to spaces

  separate_arguments( _version_list )

  list( GET _version_list 0 ${PROJECT_NAME}_VERSION_MAJOR )
  list( GET _version_list 1 ${PROJECT_NAME}_VERSION_MINOR )
  list( GET _version_list 2 ${PROJECT_NAME}_VERSION_PATCH )

  # cleanup patch version of any extra qualifiers ( -dev -rc1 ... )

  string( REGEX REPLACE "^([0-9]+).*" "\\1" ${PROJECT_NAME}_VERSION_PATCH "${${PROJECT_NAME}_VERSION_PATCH}" )

  set( ${PROJECT_NAME}_VERSION "${${PROJECT_NAME}_VERSION_MAJOR}.${${PROJECT_NAME}_VERSION_MINOR}.${${PROJECT_NAME}_VERSION_PATCH}")
  set( ${PROJECT_NAME}_VERSION "${${PROJECT_NAME}_VERSION}" CACHE INTERNAL "package ${PROJECT_NAME} version" )
  set( ${PROJECT_NAME}_VERSION_STR "${${PROJECT_NAME}_VERSION}" CACHE INTERNAL "package ${PROJECT_NAME} version" )
endmacro()
