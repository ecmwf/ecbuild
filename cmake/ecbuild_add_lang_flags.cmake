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
# ecbuild_add_lang_flags
# ======================
#
# This is mostly an internal function of ecbuild, wrapped by the macros ecbuild_add_c_flags,
# ecbuild_add_cxx_flags and ecbuild_add_fortran_flags.
#
# Add compiler flags to the CMAKE_${lang}_FLAGS only if supported by compiler. ::
#
#   ecbuild_add_lang_flags( FLAGS <flag1> [ <flag2> ... ]
#                           LANG [C|CXX|Fortran]
#                           [ BUILD <build> ]
#                           [ NAME <name> ]
#                           [ NO_FAIL ] )
#
# Options
# -------
#
# LANG:
#   define the language to add the flag too
#
# BUILD : optional
#   add flags to `CMAKE_${lang}_FLAGS_<build>` instead of `CMAKE_${lang}_FLAGS`
#
# NAME : optional
#   name of the check (if omitted, checks are enumerated)
#
# NO_FAIL : optional
#   do not fail if the flag cannot be added
#
##############################################################################

function( ecbuild_add_lang_flags )

  ecbuild_debug("call ecbuild_add_lang_flags( ${ARGV} )")

  set( options NO_FAIL )
  set( single_value_args BUILD NAME LANG )
  set( multi_value_args FLAGS )

  cmake_parse_arguments( _PAR "${options}" "${single_value_args}" "${multi_value_args}"  ${_FIRST_ARG} ${ARGN} )

  if(DEFINED _PAR_LANG)
    set(_lang ${_PAR_LANG})
  else()
    ecbuild_critical("ecbuild_add_lang_flags() called without LANG parameter")
  endif()

  if(DEFINED _PAR_FLAGS)
    set(_flags ${_PAR_FLAGS})
  else()
    list(FIND ARGV FLAGS ARG_FOUND)
    if( ARG_FOUND  STREQUAL -1 )
      ecbuild_critical("ecbuild_add_lang_flags() called without FLAGS parameter")
    endif()
    return()
  endif()

  # To handle the case where FLAGS is a list
  string( REPLACE ";" " " _flags "${_flags}" )


  ecbuild_debug( "CMAKE_${_lang}_COMPILER_LOADED [${CMAKE_${_lang}_COMPILER_LOADED}]" )

  if( CMAKE_${_lang}_COMPILER_LOADED )

    if( ECBUILD_TRUST_FLAGS )
      set( _flag_ok 1 )
    else()
      set( _flag_ok 0 )
    endif()

    if( NOT _flag_ok )

      if( NOT DEFINED N_${_lang}_FLAG )
        set( N_${_lang}_FLAG 0 )
      endif()

      math( EXPR N_${_lang}_FLAG "${N_${_lang}_FLAG}+1" )
      set( N_${_lang}_FLAG ${N_${_lang}_FLAG} PARENT_SCOPE ) # to increment across calls to this function

      if( NOT DEFINED _PAR_NAME )
        set(_PAR_NAME ${PROJECT_NAME}_${_lang}_FLAG_TEST_${N_${_lang}_FLAG})
      endif()

      if(${_lang} STREQUAL "C")
        ecbuild_debug( "check_c_compiler_flag( ${_flags} ${_PAR_NAME} )" )
        check_c_compiler_flag( ${_flags} ${_PAR_NAME} )
      endif()
      if(${_lang} STREQUAL "CXX")
        ecbuild_debug( "check_cxx_compiler_flag( ${_flags} ${_PAR_NAME} )" )
        check_cxx_compiler_flag( ${_flags} ${_PAR_NAME} )
      endif()
      if(${_lang} STREQUAL "Fortran")
        ecbuild_debug( "check_fortran_compiler_flag( ${_flags} ${_PAR_NAME} )" )
        check_fortran_compiler_flag( ${_flags} ${_PAR_NAME} )
      endif()

      set( _flag_ok ${${_PAR_NAME}} )
      ecbuild_debug( "${_lang} flag [${_flags}] check resulted [${_flag_ok}]" )

    endif( NOT _flag_ok )

    if( _flag_ok )

      if( _PAR_BUILD )
        set( CMAKE_${_lang}_FLAGS_${_PAR_BUILD} "${CMAKE_${_lang}_FLAGS_${_PAR_BUILD}} ${_flags}" PARENT_SCOPE )
        ecbuild_info( "Added ${_lang} flag [${_flags}] to build type ${_PAR_BUILD}" )
      else()
        set( CMAKE_${_lang}_FLAGS "${CMAKE_${_lang}_FLAGS} ${_flags}" PARENT_SCOPE )
        ecbuild_info( "Added ${_lang} flag [${_flags}]" )
      endif()

    elseif( _PAR_NO_FAIL )
      ecbuild_info( "${_lang} compiler ${CMAKE_${_lang}_COMPILER} does not recognise ${_lang} flag '${_flags}' -- skipping and continuing"  )

    else()
      ecbuild_critical( "${_lang} compiler ${CMAKE_${_lang}_COMPILER} does not recognise ${_lang} flag '${_flags}'" )

    endif( _flag_ok )

  endif( CMAKE_${_lang}_COMPILER_LOADED )

endfunction()
