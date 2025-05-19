# (C) Copyright 2011- ECMWF.
#
# This software is licensed under the terms of the Apache Licence Version 2.0
# which can be obtained at http://www.apache.org/licenses/LICENSE-2.0.
# In applying this licence, ECMWF does not waive the privileges and immunities
# granted to it by virtue of its status as an intergovernmental organisation
# nor does it submit to any jurisdiction.

# - Try to find ARMPL
# Once done this will define
#
#  ARMPL_FOUND         - system has ARM Performance Libraries
#  ARMPL_INCLUDE_DIRS  - the ARMPL include directories
#  ARMPL_LIBRARIES     - link these to use ARMPL
#
# The following paths will be searched with priority if set in CMake or env
#
#  ARMPLROOT           - root directory of the ARMPL installation
#  ARMPL_PATH          - root directory of the ARMPL installation
#  ARMPL_ROOT          - root directory of the ARMPL installation

option( ARMPL_PARALLEL "if armpl shoudl be parallel" OFF )

if( ARMPL_PARALLEL )

  set( __armpl_lib_suffix  "_mp" )

  find_package(Threads)

else()

  set( __armpl_lib_suffix "" )

endif()

# Search with priority for ARMPLROOT, ARMPL_PATH and ARMPL_ROOT if set in CMake or env
find_path(ARMPL_INCLUDE_DIR armpl.h
	  PATHS ${ARMPLROOT} ${ARMPL_PATH} ${ARMPL_ROOT} ${ARMPL_DIR} $ENV{ARMPLROOT} $ENV{ARMPL_PATH} $ENV{ARMPL_ROOT} $ENV{ARMPL_DIR}
          PATH_SUFFIXES include NO_DEFAULT_PATH)

find_path(ARMPL_INCLUDE_DIR armpl.h
          PATH_SUFFIXES include)

if( ARMPL_INCLUDE_DIR ) # use include dir to find libs

  set( ARMPL_INCLUDE_DIRS ${ARMPL_INCLUDE_DIR} )

  find_library( ARMPL_LIB
                PATHS ${ARMPLROOT} ${ARMPL_PATH} ${ARMPL_ROOT} ${ARMPL_DIR} $ENV{ARMPLROOT} $ENV{ARMPL_PATH} $ENV{ARMPL_ROOT} $ENV{ARMPL_DIR}
		PATH_SUFFIXES "lib" 
                NAMES armpl_lp64${__armpl_lib_suffix} )

  if( ARMPL_LIB )
    set( ARMPL_LIBRARIES ${ARMPL_LIB} )
  endif()

endif()

include(FindPackageHandleStandardArgs)

find_package_handle_standard_args( ARMPL DEFAULT_MSG
                                   ARMPL_LIBRARIES ARMPL_INCLUDE_DIRS )

mark_as_advanced( ARMPL_INCLUDE_DIR ARMPL_LIB )
