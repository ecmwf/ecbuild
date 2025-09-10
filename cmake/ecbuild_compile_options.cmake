# (C) Copyright 2011- ECMWF.
#
# This software is licensed under the terms of the Apache Licence Version 2.0
# which can be obtained at http://www.apache.org/licenses/LICENSE-2.0.
# In applying this licence, ECMWF does not waive the privileges and immunities
# granted to it by virtue of its status as an intergovernmental organisation nor
# does it submit to any jurisdiction.

##############################################################################
#.rst:
#
# ecbuild_compile_options
# =======================
#
# Defined variables describing compiler options for the current compiler. ::
#
# Fortran:
#   - ``ECBUILD_Fortran_COMPILE_OPTIONS_REAL4`` : Convert all unqualified REALs to 32 bit (single precision)
#   - ``ECBUILD_Fortran_COMPILE_OPTIONS_REAL8`` : Convert all unqualified REALs to 64 bit (double precision)
#   - ``ECBUILD_Fortran_COMPILE_OPTIONS_CHECK_BOUNDS`` : Bounds checking compile options
#   - ``ECBUILD_Fortran_COMPILE_OPTIONS_INIT_SNAN`` : Compile options to initialize REAL's with signaling NaN
#   - ``ECBUILD_Fortran_COMPILE_OPTIONS_FPE_TRAP`` : Compile options to trap floating-point-exceptions
#
# Example use:
#
# 1.  Application to entire scope
#
#         ecbuild_add_fortran_flags( ${ECBUILD_Fortran_COMPILE_OPTIONS_REAL8} )
#
# 2.  Application to a target with mixed language source files
#
#         target_compile_options(my_target PUBLIC
#             $<$<COMPILE_LANGUAGE:Fortran>:${ECBUILD_Fortran_COMPILE_OPTIONS_REAL8}>)
#         # A generator expression is required here to only apply the flags to Fortran files in the target.
#         # This is only needed if it is a mixed-language target.
#
# 3. On a per source file basis
#
#        set_property(SOURCE my_source.F90
#            APPEND PROPERTY COMPILE_OPTIONS ${ECBUILD_Fortran_COMPILE_OPTIONS_REAL8})
#
##############################################################################


##############################################################################
#.rst:
#
# ecbuild_define_compile_options
# ==============================
#
# Define a compile_option for a given compiler ID and language ::
#
#   ecbuild_define_compile_options( NAME <name> DESCRIPTION <description> LANGUAGE <language> [ REQUIRED ]
#                                   [ GNU <values> ] [ NEC <values> ] [ NVHPC <values> ] [ Intel <values> ]
#                                   [ IntelLLVM <values> ] [ Cray <values> ] [ Flang <values> ] [ NAG <values> ] 
#                                   [ LLVMFlang <values> ] )
#
# Options
# -------
#
# NAME <name> :
#   The name given to compile_option
#
# DESCRIPTION <description> :
#   The description of compile_option
#
# LANGUAGE <language> :
#   The compiler language the compile_options apply to
#
# GNU <values> : optional
#   The values for the compile option for GNU compiler and given LANGUAGE
#
# NEC <values> : optional
#   The values for the compile option for NEC compiler and given LANGUAGE
#
# NVHPC <values> : optional
#   The values for the compile option for NVHPC compiler and given LANGUAGE
#
# Intel <values> : optional
#   The values for the compile option for Intel compiler and given LANGUAGE
#
# IntelLLVM <values> : optional
#   The values for the compile option for IntelLLVM compiler and given LANGUAGE
#
# Cray <values> : optional
#   The values for the compile option for Cray compiler and given LANGUAGE
#
# Flang <values> : optional
#   The values for the compile option for Flang compiler and given LANGUAGE
#
# NAG <values> : optional
#   The values for the compile option for NAG compiler and given LANGUAGE
#
# LLVMFlang <values> : optional
#   The values for the compile option for LLVM Flang compiler and given LANGUAGE
#
# REQUIRED : optional
#   fail if the compile_options for the current compiler are not implemented,
#   to avoid nasty surpises
#
##############################################################################


function( ecbuild_define_compile_options )
  set( supported_compiler_ids GNU NEC NVHPC Intel IntelLLVM Cray Flang NAG LLVMFlang )

  set( options REQUIRED )
  set( single_value_args NAME DESCRIPTION LANGUAGE )
  set( multi_value_args  ${supported_compiler_ids} )

  cmake_parse_arguments( _p "${options}" "${single_value_args}" "${multi_value_args}"  ${_FIRST_ARG} ${ARGN} )

  if(_p_UNPARSED_ARGUMENTS)
    ecbuild_critical("Unknown keywords given to ecbuild_define_compiler_options(): \"${_p_UNPARSED_ARGUMENTS}\"")
  endif()
  if(NOT DEFINED _p_LANGUAGE)
    ecbuild_critical("Argument LANGUAGE is required to function ecbuild_define_compiler_options()")
  endif()
  set(lang ${_p_LANGUAGE})

  if( CMAKE_${lang}_COMPILER_LOADED)
    set(${lang}_COMPILER_ID ${CMAKE_${lang}_COMPILER_ID})
    if(ECBUILD_${lang}_COMPILER_ID)
      set(${lang}_COMPILER_ID ${ECBUILD_${lang}_COMPILER_ID})
    endif()
    foreach(compiler_id ${supported_compiler_ids})
      if(_p_${compiler_id} AND ${lang}_COMPILER_ID STREQUAL "${compiler_id}")
        set(${_p_NAME} ${_p_${compiler_id}} CACHE STRING "${_p_${DESCRIPTION}}")
        ecbuild_debug("${_p_NAME}: ${${_p_NAME}}")
      endif()
    endforeach()
    if(_p_REQUIRED)
      if( NOT DEFINED ${_p_NAME} )
        list(FIND ARGV ${${lang}_COMPILER_ID} ARG_FOUND)
        if( ARG_FOUND  STREQUAL -1 )
          ecbuild_critical(
            " Variable '${_p_NAME}' must be defined for compiler with ID ${${lang}_COMPILER_ID}.\n"
            " Description:\n"
            "   ${_p_DESCRIPTION}\n"
            " Please submit a patch. In the mean time you can provide the variable to the CMake configuration.")
        endif()
      endif()
    endif()
  endif()
endfunction()

##############################################################################

### ECBUILD_Fortran_COMPILE_OPTIONS_REAL4

ecbuild_define_compile_options(
  NAME        ECBUILD_Fortran_COMPILE_OPTIONS_REAL4
  DESCRIPTION "Compile options to convert all unqualified reals to 32 bit (single precision)"
  LANGUAGE    Fortran
  REQUIRED
  NEC         -fdefault-real=4
  NVHPC       -r4
  GNU         # empty (default)
  Intel       # empty (default)
  IntelLLVM   # empty (default)
  Cray        # empty (default)
  Flang       # empty (default)
  NAG         # empty (default)
  LLVMFlang   # empty (default)
)

### ECBUILD_Fortran_COMPILE_OPTIONS_REAL8

ecbuild_define_compile_options(
  NAME        ECBUILD_Fortran_COMPILE_OPTIONS_REAL8
  DESCRIPTION "Compile options to convert all unqualified reals and doubles to 64 bit (double precision)"
  LANGUAGE    Fortran
  REQUIRED
  GNU         -fdefault-real-8 -fdefault-double-8
  NEC         -fdefault-real=8 -fdefault-double=8
  NVHPC       -r8
  Intel       -r8
  IntelLLVM   -r8
  Cray        -sreal64
  Flang       -fdefault-real-8
  NAG         -double
  LLVMFlang   -fdefault-real-8
)

### ECBUILD_Fortran_COMPILE_OPTIONS_CHECK_BOUNDS

ecbuild_define_compile_options(
  NAME        ECBUILD_Fortran_COMPILE_OPTIONS_CHECK_BOUNDS
  DESCRIPTION "Bounds checking compile options"
  LANGUAGE    Fortran
  GNU         -fcheck=bounds
  NEC         -fcheck=bounds
  NVHPC       -Mbounds
  Intel       -check bounds
  IntelLLVM   -check bounds
  Cray        -Rb
)

### ECBUILD_Fortran_COMPILE_OPTIONS_INIT_SNAN

ecbuild_define_compile_options(
  NAME        ECBUILD_Fortran_COMPILE_OPTIONS_INIT_SNAN
  DESCRIPTION "Compile options to initialize REAL's with signaling NaN"
  LANGUAGE    Fortran
  GNU         -finit-real=snan
  Intel       -init=snan
  IntelLLVM   -init=snan
  Cray        -ei
)

### ECBUILD_Fortran_COMPILE_OPTIONS_FPE_TRAP

ecbuild_define_compile_options(
  NAME        ECBUILD_Fortran_COMPILE_OPTIONS_FPE_TRAP
  DESCRIPTION "Compile options to trap floating-point-exceptions"
  LANGUAGE    Fortran
  GNU         -ffpe-trap=invalid,zero,overflow
  Intel       -fpe0
  IntelLLVM   -fpe0
  NVHPC       -Ktrap=fp
  Cray        -Ktrap=fp
  Flang       -ffp-exception-behavior=strict
)
