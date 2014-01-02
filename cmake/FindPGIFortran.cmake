# (C) Copyright 1996-2012 ECMWF.
# 
# This software is licensed under the terms of the Apache Licence Version 2.0
# which can be obtained at http://www.apache.org/licenses/LICENSE-2.0. 
# In applying this licence, ECMWF does not waive the privileges and immunities 
# granted to it by virtue of its status as an intergovernmental organisation nor
# does it submit to any jurisdiction.

###############################################################################
# FORTRAN support

# list( APPEND pg_libs pgmp pgbind numa pgf90 pgf90_rpm1 pgf902 pgf90rtl  pgftnrtl nspgc pgc rt pgsse1 pgsse2 ) # init
# list( APPEND pg_libs pgf90 pgf90_rpm1 pgf902 pgf90rtl pgftnrtl pghpf pgc pgf90 rt pgsse1 pgsse2 )             # mars client linux.2
# list( APPEND pg_libs pgftnrtl nspgc pgc rt pgsse1 pgsse2 )                                                    # mars client linux.3

list( APPEND pg_libs pgmp pgbind numa pgf90 pgf90_rpm1 pgf902 pgf90rtl pgftnrtl pghpf nspgc pgc pgf90 pgf902 pghpf_rpm1 pghpf2 pgsse1 pgsse2 ) # better ?                                                    #

set( pgi_fortran_all_libs_found 1 )

foreach( pglib ${pg_libs} )

	find_library( ${pglib}_lib  ${pglib} PATHS ${PGI_PATH} PATH_SUFFIXES lib libso NO_DEFAULT_PATH )

	find_library( ${pglib}_lib  ${pglib} HINTS /usr/local/apps/pgi/pgi-10.8/linux86-64/10.8 PATH PATH_SUFFIXES lib libso )

    if( ${pglib}_lib )
        list( APPEND PGIFORTRAN_LIBRARIES ${${pglib}_lib} )
#	else()
#		set( pgi_fortran_all_libs_found 0 )
    endif()

endforeach()

include(FindPackageHandleStandardArgs)

find_package_handle_standard_args( LIBPGIFORTRAN DEFAULT_MSG pgi_fortran_all_libs_found PGIFORTRAN_LIBRARIES  )

if( LIBPGIFORTRAN_FOUND )
	find_package( Realtime )
endif()

set( LIBPGIFORTRAN_LIBRARIES ${PGIFORTRAN_LIBRARIES} ${RT_LIB} )
