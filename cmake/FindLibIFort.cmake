# © Copyright 1996-2015 ECMWF.
# 
# This software is licensed under the terms of the Apache Licence Version 2.0
# which can be obtained at http://www.apache.org/licenses/LICENSE-2.0. 
# In applying this licence, ECMWF does not waive the privileges and immunities 
# granted to it by virtue of its status as an intergovernmental organisation
# nor does it submit to any jurisdiction.

# date:   July 2015
# author: Florian Rathgeber

###############################################################################

# - Try to find Intel Fortran (ifort) runtime libraries
# Once done this will define
#
#  LIBIFORT_FOUND   - system has Intel Fortran (ifort) runtime libraries
#  IFORT_LIBRARIES  - the Intel Fortran (ifort) runtime libraries
#
# The libraries libifcore and libifport are assumed to be on either the
# LIBRARY_PATH or the LD_LIBRARY_PATH

find_library( IFORT_LIB_CORE ifcore PATHS ENV LIBRARY_PATH LD_LIBRARY_PATH )
find_library( IFORT_LIB_PORT ifport PATHS ENV LIBRARY_PATH LD_LIBRARY_PATH )

mark_as_advanced( IFORT_LIB_CORE IFORT_LIB_PORT )

if( IFORT_LIB_CORE AND IFORT_LIB_PORT )
  set( IFORT_LIBRARIES ${IFORT_LIB_CORE} ${IFORT_LIB_PORT} )
endif()

include(FindPackageHandleStandardArgs)

find_package_handle_standard_args( LIBIFORT DEFAULT_MSG IFORT_LIBRARIES )
