# © Copyright 1996-2012 ECMWF.
# 
# This software is licensed under the terms of the Apache Licence Version 2.0
# which can be obtained at http://www.apache.org/licenses/LICENSE-2.0. 
# In applying this licence, ECMWF does not waive the privileges and immunities 
# granted to it by virtue of its status as an intergovernmental organisation nor
# does it submit to any jurisdiction.

###############################################################################
# gfortran libs

set( __libgfortran_names gfortran libgfortran.so.1 libgfortran.so.3 )

find_library( GFORTRAN_LIB NAMES ${__libgfortran_names}  HINTS ${LIBGFORTRAN_PATH} ENV LIBGFORTRAN_PATH PATHS PATH_SUFFIXES lib64 lib NO_DEFAULT_PATH )
find_library( GFORTRAN_LIB NAMES ${__libgfortran_names}  PATHS PATH_SUFFIXES lib64 lib )

mark_as_advanced( GFORTRAN_LIB )

if( GFORTRAN_LIB )
	set( GFORTRAN_LIBRARIES ${GFORTRAN_LIB} )
endif()

include(FindPackageHandleStandardArgs)

find_package_handle_standard_args( LIBGFORTRAN  DEFAULT_MSG GFORTRAN_LIBRARIES  )


