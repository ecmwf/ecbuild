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
# ecbuild_remove_fortran_flags
# ============================
#
# Remove Fortran compiler flags from ``CMAKE_Fortran_FLAGS``. ::
#
#   ecbuild_remove_fortran_flags( <flag1> [ <flag2> ... ] [ BUILD <build> ] [ PROJECT ] )
#
# Options
# -------
#
# BUILD : optional
#   remove flags from ``CMAKE_Fortran_FLAGS_<build>`` instead of
#   ``CMAKE_Fortran_FLAGS``
#
# PROJECT : optional
#   remove flags from project specific ``${PNAME}_Fortran_FLAGS`` and
#   ``${PNAME}_Fortran_FLAGS_<build>`` instead of the corresponding
#   ``CMAKE_Fortran_FLAGS`` variables.
#
##############################################################################

include( CheckFortranCompilerFlag )
macro( ecbuild_remove_fortran_flags )

  set( options PROJECT )
  set( single_value_args BUILD )
  set( multi_value_args )
  cmake_parse_arguments( _PAR "${options}" "${single_value_args}" "${multi_value_args}" ${ARGV} )

  set( _flags ${_PAR_UNPARSED_ARGUMENTS} )
  if( _flags AND CMAKE_Fortran_COMPILER_LOADED )

    string( TOUPPER ${CMAKE_BUILD_TYPE} CMAKE_BUILD_TYPE_CAPS )

    if( _PAR_PROJECT )
      set( _compile_flags_base_var ${PNAME}_Fortran_FLAGS )
    else()
      set( _compile_flags_base_var CMAKE_Fortran_FLAGS )
    endif()

    if( _PAR_BUILD )
      string( TOUPPER ${_PAR_BUILD} _PAR_BUILD_CAPS )
      if( CMAKE_BUILD_TYPE_CAPS MATCHES "${_PAR_BUILD_CAPS}" )
        set( _compile_flags_var ${_compile_flags_base_var}_${_PAR_BUILD} )
        if( DEFINED ${_compile_flags_var} )
          foreach( _flag ${_flags} )
            string(REGEX REPLACE "(^|[ ]+)${_flag}($|[ ]+)" "\\1" ${_compile_flags_var} "${${_compile_flags_var}}" )
            if( _PAR_PROJECT )
              ecbuild_debug( "Fortran FLAG [${_flag}] removed from project build type ${_PAR_BUILD}" )
            else()
              ecbuild_debug( "Fortran FLAG [${_flag}] removed from build type ${_PAR_BUILD}" )
            endif()
          endforeach()
        endif()
      endif()
    else()
      set( _compile_flags_btype_var ${_compile_flags_base_var}_${CMAKE_BUILD_TYPE_CAPS} )
      foreach( _flag ${_flags} )
        if( DEFINED ${_compile_flags_btype_var} )
          string(REGEX REPLACE "(^|[ ]+)${_flag}($|[ ]+)" "\\1" ${_compile_flags_btype_var} "${${_compile_flags_btype_var}}" )
        endif()
        if( DEFINED ${_compile_flags_base_var} )
          string(REGEX REPLACE "(^|[ ]+)${_flag}($|[ ]+)" "\\1" ${_compile_flags_base_var} "${${_compile_flags_base_var}}" )
        endif()
        if( _PAR_PROJECT )
          ecbuild_debug( "Fortran FLAG [${_flag}] removed from project flags" )
        else()
          ecbuild_debug( "Fortran FLAG [${_flag}] removed" )
        endif()
      endforeach()
    endif()

  endif()
  unset( _flags )

endmacro()
