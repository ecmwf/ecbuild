# (C) Copyright 1996-2012 ECMWF.
#
# This software is licensed under the terms of the Apache Licence Version 2.0
# which can be obtained at http://www.apache.org/licenses/LICENSE-2.0.
# In applying this licence, ECMWF does not waive the privileges and immunities
# granted to it by virtue of its status as an intergovernmental organisation nor
# does it submit to any jurisdiction.

############################################################################################
# macro to find MPI
# uses the canonical find_package( MPI )
# but does more checks

macro( ecbuild_find_mpi )

    # parse parameters

    set( options REQUIRED )
	set( single_value_args )
    set( multi_value_args  )

    cmake_parse_arguments( _PAR "${options}" "${single_value_args}" "${multi_value_args}"  ${_FIRST_ARG} ${ARGN} )

    if(_PAR_UNPARSED_ARGUMENTS)
      message(FATAL_ERROR "Unknown keywords given to ecbuild_find_mpi(): \"${_PAR_UNPARSED_ARGUMENTS}\"")
    endif()

    # get_property( langs GLOBAL PROPERTY ENABLED_LANGUAGES )
    # foreach( lang ${langs} )
    #     message( STATUS " ${lang} > ${CMAKE_${lang}_COMPILER_ID} ${CMAKE_${lang}_COMPILER_VERSION} [${CMAKE_${lang}_COMPILER} ${EC_${lang}_FLAGS_ALL}]" )
    # endforeach()

    # if user defined compilers are MPI compliant, then we use them ...

    # C

	if( CMAKE_C_COMPILER_LOADED AND NOT MPI_C_COMPILER )

		include(CheckCSourceCompiles)

		check_c_source_compiles("
			#include <mpi.h>
			int main(int argc, char* argv[])
			{
			int rank;
			MPI_Init(&argc, &argv); 
			MPI_Comm_rank(MPI_COMM_WORLD, &rank); 
			MPI_Finalize();
			return 0;
			}
			"
		    C_COMPILER_SUPPORTS_MPI )

		if( C_COMPILER_SUPPORTS_MPI )
			message( STATUS "C compiler supports MPI -- ${CMAKE_C_COMPILER}" )
			set( MPI_C_COMPILER ${CMAKE_C_COMPILER} )
		endif()

    endif()

    # CXX

	if( CMAKE_CXX_COMPILER_LOADED AND NOT MPI_CXX_COMPILER )

		include(CheckCXXSourceCompiles)

		check_cxx_source_compiles("
			#include <mpi.h>
			 #include <iostream>
		     int main(int argc, char* argv[])
		     {
		       MPI_Init(&argc, &argv); int rank; MPI_Comm_rank(MPI_COMM_WORLD, &rank); MPI_Finalize();
		       return 0;
		     }
		     "
		     CXX_COMPILER_SUPPORTS_MPI )

		if( CXX_COMPILER_SUPPORTS_MPI )
			message( STATUS "C++ compiler supports MPI -- ${CMAKE_CXX_COMPILER}" )
			set( MPI_CXX_COMPILER ${CMAKE_CXX_COMPILER} )
		endif()

    endif()

    # Fortran

	if( CMAKE_Fortran_COMPILER_LOADED AND NOT MPI_Fortran_COMPILER )

		include(CheckFortranSourceCompiles)

		check_fortran_source_compiles("
			program main
			use MPI
			integer ierr
			call MPI_INIT( ierr )
			call MPI_FINALIZE( ierr )
			end
			"
		Fortran_COMPILER_SUPPORTS_MPI )

		if( Fortran_COMPILER_SUPPORTS_MPI )
			message( STATUS "Fortran compiler supports MPI (F90) -- ${CMAKE_Fortran_COMPILER}" )
			set( MPI_Fortran_COMPILER ${CMAKE_Fortran_COMPILER} )
		endif()

    endif()

    # canonical MPI search

	find_package( MPI )

    # hide these variables from UI

    mark_as_advanced( MPI_LIBRARY MPI_EXTRA_LIBRARY )

endmacro( ecbuild_find_mpi )
