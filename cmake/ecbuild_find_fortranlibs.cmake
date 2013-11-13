# (C) Copyright 1996-2012 ECMWF.
#
# This software is licensed under the terms of the Apache Licence Version 2.0
# which can be obtained at http://www.apache.org/licenses/LICENSE-2.0.
# In applying this licence, ECMWF does not waive the privileges and immunities
# granted to it by virtue of its status as an intergovernmental organisation nor
# does it submit to any jurisdiction.

############################################################################################
# macro to find fortran (static) link libraries


macro( ecbuild_find_fortranlibs )

    # parse parameters

    set( options REQUIRED )
    set( single_value_args )
    set( multi_value_args  )

    cmake_parse_arguments( _PAR "${options}" "${single_value_args}" "${multi_value_args}"  ${_FIRST_ARG} ${ARGN} )

    if(_PAR_UNPARSED_ARGUMENTS)
      message(FATAL_ERROR "Unknown keywords given to ecbuild_find_python(): \"${_PAR_UNPARSED_ARGUMENTS}\"")
    endif()

	if( NOT FORTRANLIBS_FOUND ) # don't repeat search

		# set path from environment variables

		foreach( _fortran_lib PGI XLF LIBGFORTRAN )
			if( NOT ${_fortran_lib}_PATH AND NOT "$ENV{${_fortran_lib}_PATH}" STREQUAL "" )
				set( ${_fortran_lib}_PATH "$ENV{${_fortran_lib}_PATH}" )
			endif()
		endforeach()

		set( _flibs_found 0 )

		# SPECIFIC SEARCH

		if( WITH_PGI_FORTRAN OR DEFINED PGI_PATH )
			find_package(PGIFortran)
			if( LIBPGIFORTRAN_FOUND )
				set( FORTRAN_LIBRARIES ${PGIFORTRAN_LIBRARIES} )
				set( _flibs_found 1 )
				set( _flibs_txt "PGI" )
			endif()
		endif()

		if( WITH_LIBGFORTRAN OR DEFINED LIBGFORTRAN_PATH )
			find_package(LibGFortran)
			if( LIBGFORTRAN_FOUND )
				set( FORTRAN_LIBRARIES ${LIBGFORTRAN_LIBRARIES} )
				set( _flibs_found 1 )
				set( _flibs_txt "gfortran" )
			endif()
		endif()

		if( WITH_XL_FORTRAN OR DEFINED XLF_PATH )
			find_package(XLFortranLibs)
			if( LIBXLFORTRAN_FOUND )
				set( FORTRAN_LIBRARIES ${XLFORTRAN_LIBRARIES} )
				set( _flibs_found 1 )
				set( _flibs_txt "XLF" )
			endif()
		endif()

		# DEFAULT SEARCHING
		# default is to search for PGI -> Gfortran -> XLF

		if( NOT WITH_PGI_FORTRAN AND NOT WITH_LIBGFORTRAN AND NOT WITH_XL_FORTRAN )

			if( NOT _flibs_found )
				find_package(PGIFortran)
				if( LIBPGIFORTRAN_FOUND )
					set( FORTRAN_LIBRARIES ${PGIFORTRAN_LIBRARIES} )
					set( _flibs_found 1 )
					set( _flibs_txt "PGI" )
				endif()
			endif()

			if( NOT _flibs_found )
				find_package(LibGFortran)
				if( LIBGFORTRAN_FOUND )
					set( FORTRAN_LIBRARIES ${LIBGFORTRAN_LIBRARIES} )
					set( _flibs_found 1 )
					set( _flibs_txt "gfortran" )
				endif()
			endif()

			if( NOT _flibs_found )
				find_package(XLFortranLibs)
				if( LIBXLFORTRAN_FOUND )
					set( FORTRAN_LIBRARIES ${XLFORTRAN_LIBRARIES} )
					set( _flibs_found 1 )
					set( _flibs_txt "XLF" )
				endif()
			endif()

		endif()

		# set found
		if( _flibs_found )
			set( FORTRANLIBS_FOUND 1 CACHE INTERNAL "Fortran libraries found" )
			set( FORTRANLIBS_NAME ${_flibs_txt}  CACHE INTERNAL "Fortran library name" )
			set( FORTRAN_LIBRARIES ${FORTRAN_LIBRARIES} CACHE INTERNAL "Fortran libraries" )
			message( STATUS "Found Fortran libraries: ${_flibs_txt}" )
		else()
			set( FORTRANLIBS_FOUND 0 )
			if( _PAR_REQUIRED )
			   message( FATAL_ERROR "Failed to find Fortran libraries" )
			else()
			   message( STATUS "Failed to find Fortran libraries" )
			endif()
		endif()

	endif( NOT FORTRANLIBS_FOUND )

endmacro( ecbuild_find_fortranlibs )
