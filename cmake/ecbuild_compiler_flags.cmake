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
# ecbuild_compiler_flags
# ======================
#
# Set compiler specific default compilation flags for a given language. ::
#
#   ecbuild_compiler_flags( <lang> )
#
# The procedure is as follows:
#
# 1.  ecBuild does **not** set ``CMAKE_<lang>_FLAGS`` i.e. the user can set
#     these via ``-D`` or the CMake cache and these will be the "base" flags.
#
# 2.  ecBuild **overwrites** ``CMAKE_<lang>_FLAGS_<btype>`` in the CMake cache
#     for all build types with compiler specific defaults for the currently
#     loaded compiler i.e. any value set by the user via ``-D`` or the CMake
#     cache **has no effect**.
#
# 3.  Any value the user provides via ``ECBUILD_<lang>_FLAGS`` or
#     ``ECBUILD_<lang>_FLAGS_<btype>`` **overrides** the corresponding
#     ``CMAKE_<lang>_FLAGS`` or ``CMAKE_<lang>_FLAGS_<btype>`` **without being
#     written to the CMake cache**.
#
##############################################################################

macro( ecbuild_compiler_flags _lang )

  # Set compiler and language specific default flags - OVERWRITES variables in CMake cache
  if( CMAKE_${_lang}_COMPILER_LOADED )
    ecbuild_debug( "ecbuild_compiler_flags(${_lang}): try include ${ECBUILD_MACROS_DIR}/compiler_flags/${CMAKE_${_lang}_COMPILER_ID}_${_lang}.cmake ")
    include( ${ECBUILD_MACROS_DIR}/compiler_flags/${CMAKE_${_lang}_COMPILER_ID}_${_lang}.cmake OPTIONAL )
  endif()

  set (_btypelist NONE DEBUG BIT PRODUCTION RELEASE RELWITHDEBINFO)

  if (NOT "${CMAKE_BUILD_TYPE}" IN_LIST _btypelist)
    list (APPEND _btypelist "${CMAKE_BUILD_TYPE}")
  endif ()

  # Apply user or toolchain specified compilation flag overrides (NOT written to cache)

  foreach( _btype IN LISTS _btypelist)
    if( DEFINED ECBUILD_${_lang}_FLAGS_${_btype} )
      ecbuild_debug( "ecbuild_compiler_flags(${_lang}): overriding CMAKE_${_lang}_FLAGS_${_btype} with ${ECBUILD_${_lang}_FLAGS_${_btype}}")
      set( CMAKE_${_lang}_FLAGS_${_btype} ${ECBUILD_${_lang}_FLAGS_${_btype}} )
    endif()
    mark_as_advanced( CMAKE_${_lang}_FLAGS_${_btype} )
  endforeach()

  if( DEFINED ECBUILD_${_lang}_FLAGS )
    ecbuild_debug( "ecbuild_compiler_flags(${_lang}): overriding CMAKE_${_lang}_FLAGS with ${ECBUILD_${_lang}_FLAGS}")
    set( CMAKE_${_lang}_FLAGS "${ECBUILD_${_lang}_FLAGS}" )
  endif()

  mark_as_advanced( CMAKE_${_lang}_FLAGS )

  if( DEFINED ECBUILD_${_lang}_LINK_FLAGS )
    ecbuild_debug( "ecbuild_compiler_flags(${_lang}): overriding CMAKE_${_lang}_LINK_FLAGS with ${ECBUILD_${_lang}_LINK_FLAGS}")
    set( CMAKE_${_lang}_LINK_FLAGS "${ECBUILD_${_lang}_LINK_FLAGS}" )
  endif()

  mark_as_advanced( CMAKE_${_lang}_LINK_FLAGS )

  ecbuild_debug_var( CMAKE_${_lang}_FLAGS )
  foreach( _btype IN LISTS _btypelist)
    ecbuild_debug_var( CMAKE_${_lang}_FLAGS_${_btype} )
  endforeach()

endmacro()

##############################################################################
#.rst:
#
# ecbuild_purge_compiler_flags
# ============================
#
# Purge compiler flags for a given language ::
#
#   ecbuild_purge_compiler_flags( <lang> )
#
##############################################################################

macro( ecbuild_purge_compiler_flags _lang )

    set( options WARN )
    set( oneValueArgs "" )
    set( multiValueArgs "" )

    set (_btypelist ALL DEBUG BIT PRODUCTION RELEASE RELWITHDEBINFO)

    if (NOT "${CMAKE_BUILD_TYPE}" IN_LIST _btypelist)
      list (APPEND _btypelist "${CMAKE_BUILD_TYPE}")
    endif ()

    cmake_parse_arguments( _PAR "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN} )

    if( CMAKE_${_lang}_COMPILER_LOADED )

      # Clear default compilation flags potentially inherited from parent scope
      # when using custom compilation flags
      if( ECBUILD_SOURCE_FLAGS OR ECBUILD_COMPILE_FLAGS )
        set(CMAKE_${_lang}_FLAGS "")
        foreach( _btype IN LISTS _btypelist)
          set(CMAKE_${_lang}_FLAGS_${_btype} "")
        endforeach()
      endif()

    endif()

    if( ${_PAR_WARN} )
      ecbuild_warn( "Purging compiler flags set for ${_lang}" )
    endif()

endmacro()

##############################################################################
#.rst:
#
# ecbuild_linker_flags
# ====================
#
# Apply user or toolchain specified linker flag overrides per object type (NOT written to cache)
#
#   ecbuild_linker_flags()
#
##############################################################################

macro( ecbuild_linker_flags )
  foreach( _obj EXE SHARED MODULE )
    if( ECBUILD_${_obj}_LINKER_FLAGS )
      set( CMAKE_${_obj}_LINKER_FLAGS ${ECBUILD_${_obj}_LINKER_FLAGS} )
    endif()
  
    if( NOT "$ENV{LD_RUN_PATH}" EQUAL "" )
      set( LD_RUN_PATH "$ENV{LD_RUN_PATH}" )
      string( REPLACE ":" ";" LD_RUN_PATH "$ENV{LD_RUN_PATH}" )
      foreach( rpath ${LD_RUN_PATH} )
        ecbuild_regex_escape( "${rpath}" rpath_escaped )
        if( NOT CMAKE_${_obj}_LINKER_FLAGS MATCHES ".*-Wl,-rpath,${rpath_escaped}.*")
          set( CMAKE_${_obj}_LINKER_FLAGS "${CMAKE_${_obj}_LINKER_FLAGS} -Wl,-rpath,${rpath}" )
        endif()
      endforeach()
    endif()
  endforeach()
  
  set (_btypelist NONE DEBUG BIT PRODUCTION RELEASE RELWITHDEBINFO)

  if (NOT "${CMAKE_BUILD_TYPE}" IN_LIST _btypelist)
    list (APPEND _btypelist "${CMAKE_BUILD_TYPE}")
  endif ()

  foreach( _btype IN LISTS _btypelist)
  
    foreach( _obj EXE SHARED MODULE )
      if( ECBUILD_${_obj}_LINKER_FLAGS_${_btype} )
        set( CMAKE_${_obj}_LINKER_FLAGS_${_btype} ${ECBUILD_${_obj}_LINKER_FLAGS_${_btype}} )
      endif()
    endforeach()
  
  endforeach()
endmacro()

##############################################################################
#.rst:
#
# ecbuild_override_compiler_flags
# ===============================
#
# Purge existing CMAKE_<lang>_FLAGS flags and trigger the use of per source
# file overrideable flags (see ``Using custom compilation flags`` for an
# explanation).
#
#   ecbuild_override_compiler_flags()
#
##############################################################################

macro( ecbuild_override_compiler_flags )

    set( options "" )
    set( oneValueArgs SOURCE_FLAGS COMPILE_FLAGS )
    set( multiValueArgs "" )

    cmake_parse_arguments( _PAR "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN} )

    # Ensure COMPILE/SOURCE_FLAGS is a valid file path
    if( DEFINED _PAR_COMPILE_FLAGS AND NOT EXISTS ${_PAR_COMPILE_FLAGS} )
      ecbuild_warn( "COMPILE_FLAGS points to non-existent file ${_PAR_COMPILE_FLAGS} and will be ignored" )
      unset( ECBUILD_COMPILE_FLAGS )
      unset( ECBUILD_COMPILE_FLAGS CACHE )
    elseif( DEFINED _PAR_SOURCE_FLAGS AND NOT EXISTS ${_PAR_SOURCE_FLAGS} )
      ecbuild_warn( "SOURCE_FLAGS points to non-existent file ${_PAR_SOURCE_FLAGS} and will be ignored" )
      unset( ECBUILD_SOURCE_FLAGS )
      unset( ECBUILD_SOURCE_FLAGS CACHE )
    elseif( DEFINED _PAR_SOURCE_FLAGS OR DEFINED _PAR_COMPILE_FLAGS )
       foreach( _lang C CXX Fortran )
         if( CMAKE_${_lang}_COMPILER_LOADED )
          ecbuild_purge_compiler_flags( ${_lang} WARN )
         endif()
       endforeach()
   
       if( DEFINED _PAR_COMPILE_FLAGS )
          if( DEFINED ECBUILD_COMPILE_FLAGS)
            ecbuild_debug( "Override ECBUILD_COMPILE_FLAGS (${ECBUILD_COMPILE_FLAGS}) with ${_PAR_COMPILE_FLAGS}" )
          endif()
          set( ECBUILD_COMPILE_FLAGS ${_PAR_COMPILE_FLAGS} )
          include( ${ECBUILD_COMPILE_FLAGS} )
       elseif( DEFINED _PAR_SOURCE_FLAGS )
          if( DEFINED ECBUILD_SOURCE_FLAGS)
            ecbuild_debug( "Override ECBUILD_SOURCE_FLAGS (${ECBUILD_SOURCE_FLAGS}) with ${_PAR_SOURCE_FLAGS}" )
          endif()
          set( ECBUILD_SOURCE_FLAGS ${_PAR_SOURCE_FLAGS} )
       endif()
   
       ecbuild_linker_flags()
    endif()

endmacro()

##############################################################################
#.rst:
#
# Using custom compilation flags
# ==============================
#
# If compilation flags need to be controlled on a per source file basis,
# ecBuild supports defining custom rules in a CMake or JSON file.
#
# When using this approach, *default compilation flags are NOT loaded*!
#
# Overriding compilation flags on a per source file basis using CMake rules
# -------------------------------------------------------------------------
#
# Compiler flags can be overridden on a per source file basis by setting the
# CMake variable ``ECBUILD_COMPILE_FLAGS`` to the *full path* of a CMake file
# defining the override rules. If set, ``<PNAME>_ECBUILD_COMPILE_FLAGS``
# takes precendence and ``ECBUILD_COMPILE_FLAGS`` is ignored, allowing for
# rules that only apply to a subproject (e.g. in a bundle).
#
# Flags can be overridden in 3 different ways:
#
# 1.  By defining project specific flags for a language and (optionally)
#     build type e.g. ::
#
#       set(<PNAME>_Fortran_FLAGS "...") # common flags for all build types
#       set(<PNAME>_Fortran_FLAGS_DEBUG "...") # only for DEBUG build type
#
# 2.  By defining source file specific flags which are *combined* with the
#     project and target specific flags ::
#
#       set_source_files_properties(<source>
#         PROPERTIES COMPILE_FLAGS "..."  # common flags for all build types
#                    COMPILE_FLAGS_DEBUG "...") # only for DEBUG build type
#
# 3.  By defining source file specific flags which *override* the project and
#     target specific flags ::
#
#       set_source_files_properties(<source>
#         PROPERTIES OVERRIDE_COMPILE_FLAGS "..."
#                    OVERRIDE_COMPILE_FLAGS_DEBUG "...")
#
# See ``examples/override-compile-flags`` in the ecBuild source tree for a
# complete example using this technique.
#
# Overriding compilation flags on a per source file basis using JSON rules
# ------------------------------------------------------------------------
#
# Compiler flags can be overridden on a per source file basis by setting the
# CMake variable ``ECBUILD_SOURCE_FLAGS`` to the *full path* of a JSON file
# defining the override rules. If set, ``<PNAME>_ECBUILD_SOURCE_FLAGS``
# takes precendence and ``ECBUILD_SOURCE_FLAGS`` is ignored, allowing for
# rules that only apply to a subproject (e.g. in a bundle).
#
# The JSON file lists shell glob patterns and the rule to apply to each source
# file matching the pattern, defined as an array ``[op, flag1, ...]``
# containing an operator followed by one or more flags. Valid operators are:
#
# :+: Add the flags to the default compilation flags for matching files
# :=: Set the flags for matching files, disregarding default compilation flags
# :/: Remove the flags from the default compilation flags for matching files
#
# Rules can be nested to e.g. only apply to a subdirectory by setting the rule
# to a dictionary, which will only apply to source files matching its pattern.
#
# An example JSON file demonstrating different rule types is given below: ::
#
#   {
#     "*"       : [ "+", "-g0" ],
#     "*.cxx"   : [ "+", "-cxx11" ],
#     "*.f90"   : [ "+", "-pipe" ],
#     "foo.c"   : [ "+", "-O0" ],
#     "foo.cc"  : [ "+", "-O2", "-pipe" ],
#     "bar/*": {
#       "*.f90" : [ "=", "-O1" ]
#     },
#     "baz/*": {
#       "*.f90" : [ "/", "-pipe" ],
#       "*.f90" : [ "/", "-O2" ],
#       "*.f90" : [ "+", "-O3" ]
#     }
#   }
#
# See ``examples/override-compile-flags`` in the ecBuild source tree for a
# complete example using this technique.
#
##############################################################################

# We need to detect if the Fortran compiler is NEC, as it identifies as GNU
# and some compiler flags are different than for GNU.
# The resulting compiler ID "NEC" is then stored in ECBUILD_Fortran_COMPILER_ID
# without modifying CMAKE_Fortran_COMPILER_ID.

if( CMAKE_Fortran_COMPILER_LOADED )
  set( _compiler_id ${CMAKE_Fortran_COMPILER_ID} )
  if( NOT DEFINED ECBUILD_Fortran_COMPILER_ID AND CMAKE_Fortran_COMPILER_ID STREQUAL "GNU" )
    try_compile( _is_nec ${CMAKE_CURRENT_BINARY_DIR} ${CMAKE_CURRENT_LIST_DIR}/determine-nec.F90 )
    if( _is_nec )
      ecbuild_info("NEC Fortran compiler detected")
      set( _compiler_id NEC )
    endif()
  endif()
  set(ECBUILD_Fortran_COMPILER_ID ${_compiler_id} CACHE STRING "CMAKE_Fortran_COMPILER_ID")
endif()
include(ecbuild_compile_options)

string( TOUPPER ${PROJECT_NAME} PROJECT_NAME_CAPS )

# Custom (project specific) compilation flags enabled?
foreach( _flags COMPILE SOURCE )
  if( ${PROJECT_NAME_CAPS}_ECBUILD_${_flags}_FLAGS )
    if ( ECBUILD_${_flags}_FLAGS )
      ecbuild_debug( "Override ECBUILD_${_flags}_FLAGS (${ECBUILD_${_flags}_FLAGS}) with ${PROJECT_NAME} specific flags (${${PROJECT_NAME_CAPS}_ECBUILD_${_flags}_FLAGS})" )
    else()
      ecbuild_debug( "Use ${PROJECT_NAME} specific ECBUILD_${_flags}_FLAGS (${${PROJECT_NAME_CAPS}_ECBUILD_${_flags}_FLAGS})" )
    endif()
    set( ECBUILD_${_flags}_FLAGS ${${PROJECT_NAME_CAPS}_ECBUILD_${_flags}_FLAGS} )
  endif()
endforeach()
if( DEFINED ECBUILD_COMPILE_FLAGS )
  ecbuild_override_compiler_flags( COMPILE_FLAGS ${ECBUILD_COMPILE_FLAGS} )
elseif( DEFINED ECBUILD_SOURCE_FLAGS )
  ecbuild_override_compiler_flags( SOURCE_FLAGS ${ECBUILD_SOURCE_FLAGS} )
endif()

foreach( _lang C CXX Fortran )
  if( CMAKE_${_lang}_COMPILER_LOADED )

    # Load default compilation flags only if custom compilation flags not enabled
    if( NOT (DEFINED ECBUILD_SOURCE_FLAGS OR DEFINED ECBUILD_COMPILE_FLAGS) )
      ecbuild_compiler_flags( ${_lang} )
    endif()

  endif()
endforeach()

if( NOT DEFINED ECBUILD_COMPILE_FLAGS AND NOT DEFINED ECBUILD_SOURCE_FLAGS )
   ecbuild_linker_flags()
endif()

