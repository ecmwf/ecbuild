# © Copyright 1996-2012 ECMWF.
# 
# This software is licensed under the terms of the Apache Licence Version 2.0
# which can be obtained at http://www.apache.org/licenses/LICENSE-2.0. 
# In applying this licence, ECMWF does not waive the privileges and immunities 
# granted to it by virtue of its status as an intergovernmental organisation nor
# does it submit to any jurisdiction.

###############################################################################
# FORTRAN support

if( NOT DEFINED LIBGFORTRAN_PATH AND DEFINED $ENV{LIBGFORTRAN_PATH} )
	set( LIBGFORTRAN_PATH $ENV{LIBGFORTRAN_PATH} )
endif()

debug_var( LIBGFORTRAN_PATH )

if( DEFINED LIBGFORTRAN_PATH )
	find_library( libgfortran NAMES gfortran PATHS ${LIBGFORTRAN_PATH} ${LIBGFORTRAN_PATH}/lib64 ${LIBGFORTRAN_PATH}/lib  NO_DEFAULT_PATH )
endif()
find_library( libgfortran NAMES gfortran )
mark_as_advanced( libgfortran )

if( libgfortran )
	set( LIBGFORTRAN_LIBRARIES ${libgfortran} )
endif()

debug_var( libgfortran )

include(FindPackageHandleStandardArgs)

find_package_handle_standard_args( LIBGFORTRAN  DEFAULT_MSG LIBGFORTRAN_LIBRARIES  )


