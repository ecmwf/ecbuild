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

if( LIBGFORTRAN_PATH )
	find_library( libgfortran gfortran PATHS ${LIBGFORTRAN_PATH} PATH_SUFFIXES lib64 lib NO_DEFAULT_PATH )
endif()

find_library( libgfortran_ gfortran )

mark_as_advanced( libgfortran_ )

if( libgfortran_ )
	set( LIBGFORTRAN_LIBRARIES ${libgfortran} )
endif()

debug_var( libgfortran_ )

execute_process( COMMAND "find /usr -iname libgfortran*" OUTPUT_VARIABLE find_out RESULT_VARIABLE find_res )
debug_var(find_res)
debug_var(find_out)

include(FindPackageHandleStandardArgs)

find_package_handle_standard_args( LIBGFORTRAN  DEFAULT_MSG LIBGFORTRAN_LIBRARIES  )


