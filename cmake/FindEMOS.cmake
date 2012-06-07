# (C) Copyright 1996-2012 ECMWF.
# 
# This software is licensed under the terms of the Apache Licence Version 2.0
# which can be obtained at http://www.apache.org/licenses/LICENSE-2.0. 
# In applying this licence, ECMWF does not waive the privileges and immunities 
# granted to it by virtue of its status as an intergovernmental organisation nor
# does it submit to any jurisdiction.

# - Try to find EMOS
# Once done this will define
#  EMOS_FOUND - System has EMOS
#  EMOS_INCLUDE_DIRS - The EMOS include directories
#  EMOS_LIBRARIES - The libraries needed to use EMOS

if( NOT DEFINED EMOS_PATH AND DEFINED $ENV{EMOS_PATH} )
	set( EMOS_PATH $ENV{EMOS_PATH} )
endif()

if( DEFINED EMOS_PATH )
	find_library( EMOS_LIBRARY NAMES emos.R64.D64.I32 emos.R64 emosR64 emos PATHS ${EMOS_PATH} ${EMOS_PATH}/lib PATH_SUFFIXES emos NO_DEFAULT_PATH)
endif()

find_library( EMOS_LIBRARY  NAMES emos.R64.D64.I32 emos.R64 emosR64 emos )

set( EMOS_LIBRARIES    ${EMOS_LIBRARY} )

include(FindPackageHandleStandardArgs)

# handle the QUIETLY and REQUIRED arguments and set EMOS_FOUND to TRUE
# if all listed variables are TRUE
find_package_handle_standard_args(EMOS  DEFAULT_MSG
								  EMOS_LIBRARY )

mark_as_advanced(EMOS_LIBRARY)
