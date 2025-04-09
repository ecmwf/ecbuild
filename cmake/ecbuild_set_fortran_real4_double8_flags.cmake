# (C) Copyright 2011- ECMWF.
#
# This software is licensed under the terms of the Apache Licence Version 2.0
# which can be obtained at http://www.apache.org/licenses/LICENSE-2.0.
# In applying this licence, ECMWF does not waive the privileges and immunities
# granted to it by virtue of its status as an intergovernmental organisation
# nor does it submit to any jurisdiction.

##############################################################################
#.rst:
#
# ecbuild_set_fortran_real4_double8_flags
# ==========================================
#
# Add Fortran compiler flags to set real to 4 bytes ::
#
#   ecbuild_set_fortran_real4_double8_flags()
#
##############################################################################

include(CheckFortranCompilerFlag)
include(ecbuild_add_fortran_flags)
include(ecbuild_remove_fortran_flags)

macro( ecbuild_set_fortran_real4_double8_flags )
	ecbuild_debug("call ecbuild_set_fortran_real4_double8_flags()")
	if (CMAKE_Fortran_COMPILER_ID STREQUAL "GNU")
		# The NEC compiler also identify itself with GNU. So test if the option
		# specific to the NEC compiler exists to deduce which compiler it is
		check_fortran_compiler_flag("-fdefault-real=4" IS_NEC)
		if(IS_NEC) #NEC
			ecbuild_remove_fortran_flags( "-fdefault-real=8" )
			ecbuild_add_fortran_flags( "-fdefault-real=4" )
		else() #GNU
			ecbuild_remove_fortran_flags( "-fdefault-real-8" )
			ecbuild_remove_fortran_flags( "-fdefault-real-10" )
			ecbuild_remove_fortran_flags( "-fdefault-real-16" )
		endif()
	elseif (CMAKE_Fortran_COMPILER_ID STREQUAL "Intel")
		ecbuild_remove_fortran_flags( "-r8" )
	elseif (CMAKE_Fortran_COMPILER_ID STREQUAL "IntelLLVM")
		ecbuild_remove_fortran_flags( "-r8" )
	elseif (CMAKE_Fortran_COMPILER_ID STREQUAL "NVHPC")
		ecbuild_remove_fortran_flags( "-r8" )
		ecbuild_add_fortran_flags( "-r4" )
	else()
		message(WARNING "Unknown Fortran compiler. Real might not be 4 bytes.")
	endif()
endmacro()
