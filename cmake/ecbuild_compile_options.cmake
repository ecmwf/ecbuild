# (C) Copyright 2011- ECMWF.
#
# This software is licensed under the terms of the Apache Licence Version 2.0
# which can be obtained at http://www.apache.org/licenses/LICENSE-2.0.
# In applying this licence, ECMWF does not waive the privileges and immunities
# granted to it by virtue of its status as an intergovernmental organisation nor
# does it submit to any jurisdiction.

function( ecbuild_define_compile_options )
  set( supported_compiler_ids GNU NEC NVHPC Intel IntelLLVM Cray Flang )

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
          ecbuild_critical("Variable '${_p_NAME}' must be defined for compiler with ID ${${lang}_COMPILER_ID}")
        endif()
      endif()
    endif()
  endif()
endfunction()

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
  DESCRIPTION "Compile options to initiaize REAL's with signaling NaN"
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
