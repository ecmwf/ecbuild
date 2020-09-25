# - Try to find Eigen3 lib
#
# This module supports requiring a minimum version, e.g. you can do
#   find_package(Eigen3 3.1.2)
# to require version 3.1.2 or newer of Eigen3.
#
# Once done this will define
#
#  EIGEN3_FOUND - system has eigen lib with correct version
#  EIGEN3_INCLUDE_DIRS - the eigen include directory
#  EIGEN3_VERSION - eigen version
#
# First a find_package( Eigen3 NO_MODULE ) is invoked which will also define target Eigen3::Eigen
# If this is not found, a fallback mechanism is used which searches for include dirs and defines
# above variables without the target.
# To force definition of the target, set the variable `Eigen3_NO_MODULE` ON.
# To skip the find_package( Eigen3 NO_MODULE ), set the variable `Eigen3_NO_MODULE` OFF
#
# Copyright (c) 2006, 2007 Montel Laurent, <montel@kde.org>
# Copyright (c) 2008, 2009 Gael Guennebaud, <g.gael@free.fr>
# Copyright (c) 2009 Benoit Jacob <jacob.benoit.1@gmail.com>
# Copyright (c) 2013- ECMWF
# Redistribution and use is allowed according to the terms of the 2-clause BSD license.

macro(_eigen3_check_version)
  file(READ "${EIGEN3_INCLUDE_DIR}/Eigen/src/Core/util/Macros.h" _eigen3_version_header)

  string(REGEX MATCH "define[ \t]+EIGEN_WORLD_VERSION[ \t]+([0-9]+)" _eigen3_world_version_match "${_eigen3_version_header}")
  set(EIGEN3_WORLD_VERSION "${CMAKE_MATCH_1}")
  string(REGEX MATCH "define[ \t]+EIGEN_MAJOR_VERSION[ \t]+([0-9]+)" _eigen3_major_version_match "${_eigen3_version_header}")
  set(EIGEN3_MAJOR_VERSION "${CMAKE_MATCH_1}")
  string(REGEX MATCH "define[ \t]+EIGEN_MINOR_VERSION[ \t]+([0-9]+)" _eigen3_minor_version_match "${_eigen3_version_header}")
  set(EIGEN3_MINOR_VERSION "${CMAKE_MATCH_1}")

  set(EIGEN3_VERSION ${EIGEN3_WORLD_VERSION}.${EIGEN3_MAJOR_VERSION}.${EIGEN3_MINOR_VERSION})

  if( Eigen3_FIND_VERSION )

    if(${EIGEN3_VERSION} VERSION_LESS ${Eigen3_FIND_VERSION})
      set(EIGEN3_VERSION_OK FALSE)
    else(${EIGEN3_VERSION} VERSION_LESS ${Eigen3_FIND_VERSION})
      set(EIGEN3_VERSION_OK TRUE)
    endif(${EIGEN3_VERSION} VERSION_LESS ${Eigen3_FIND_VERSION})

  else()
    set( EIGEN3_VERSION_OK TRUE )
  endif()

  if(NOT EIGEN3_VERSION_OK)

    message(STATUS "Eigen3 version ${EIGEN3_VERSION} found in ${EIGEN3_INCLUDE_DIR}, "
                   "but at least version ${Eigen3_FIND_VERSION} is required")
  else()
    set( EIGEN3_VERSION ${EIGEN3_VERSION} CACHE INTERNAL "Eigen3 version" )
  endif()

endmacro(_eigen3_check_version)

if( NOT DEFINED Eigen3_NO_MODULE OR Eigen3_NO_MODULE )
  find_package( Eigen3 NO_MODULE )
  set( EIGEN3_VERSION ${Eigen3_VERSION} )
  set( EIGEN3_FOUND ${Eigen3_FOUND} )
  if( Eigen3_FOUND OR Eigen3_NO_MODULE )
    include( FindPackageHandleStandardArgs )
    find_package_handle_standard_args( Eigen3 CONFIG_MODE )
    return()
  endif()
endif()

if(EIGEN3_INCLUDE_DIR)

  # in cache already
  _eigen3_check_version()
  set(EIGEN3_FOUND ${EIGEN3_VERSION_OK})

else(EIGEN3_INCLUDE_DIR)

  find_path(EIGEN3_INCLUDE_DIR NAMES signature_of_eigen3_matrix_library
      PATHS
      ${CMAKE_INSTALL_PREFIX}/include
      ${KDE4_INCLUDE_DIR}
      ${EIGEN3_PATH}/include
      ${EIGEN3_DIR}/include
      ${EIGEN3_ROOT}/include
      ${EIGEN_PATH}/include
      ${EIGEN_DIR}/include
      ${EIGEN_ROOT}/include
      ENV EIGEN3_PATH
      ENV EIGEN3_DIR
      ENV EIGEN3_ROOT
      ENV EIGEN_PATH
      ENV EIGEN_DIR
      ENV EIGEN_ROOT
      PATH_SUFFIXES eigen3 eigen include/eigen3 include/eigen
    )

  if(EIGEN3_INCLUDE_DIR)
    _eigen3_check_version()
  endif(EIGEN3_INCLUDE_DIR)

  mark_as_advanced(EIGEN3_INCLUDE_DIR)

endif(EIGEN3_INCLUDE_DIR)

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(Eigen3 DEFAULT_MSG EIGEN3_INCLUDE_DIR EIGEN3_VERSION_OK)

set( EIGEN3_INCLUDE_DIRS ${EIGEN3_INCLUDE_DIR} )
