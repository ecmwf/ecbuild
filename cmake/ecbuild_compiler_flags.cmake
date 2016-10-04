# (C) Copyright 1996-2016 ECMWF.
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
# 1.  ecBuild does *not* set ``CMAKE_<lang>_FLAGS`` i.e. the user can set these
#     via -D or the CMake cache and these will be the "base" flags.
#
# 2.  ecBuild *overwrites* ``CMAKE_<lang>_FLAGS_<btype>`` in the CMake cache
#     for all build types with compiler specific defaults for the currently
#     loaded compiler i.e. any value set by the user via -D or the CMake cache
#     *has no effect*.
#
# 3.  Any value the user provides via ``ECBUILD_<lang>_FLAGS`` or
#     ``ECBUILD_<lang>_FLAGS_<btype>`` *overrides* the corresponding
#     ``CMAKE_<lang>_FLAGS`` or ``CMAKE_<lang>_FLAGS_<btype>`` *without being
#     written to the CMake cache*.
#
##############################################################################

macro( ecbuild_compiler_flags _lang )

  # Set compiler and language specific default flags - OVERWRITES variables in CMake cache
  if( CMAKE_${_lang}_COMPILER_LOADED )
    ecbuild_debug( "ecbuild_compiler_flags(${_lang}): try include ${ECBUILD_MACROS_DIR}/compiler_flags/${CMAKE_${_lang}_COMPILER_ID}_${_lang}.cmake ")
    include( ${ECBUILD_MACROS_DIR}/compiler_flags/${CMAKE_${_lang}_COMPILER_ID}_${_lang}.cmake OPTIONAL )
  endif()

  # Apply user or toolchain specified compilation flag overrides (NOT written to cache)

  foreach( _btype NONE DEBUG BIT PRODUCTION RELEASE RELWITHDEBINFO )
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
  foreach( _btype NONE DEBUG BIT PRODUCTION RELEASE RELWITHDEBINFO )
    ecbuild_debug_var( CMAKE_${_lang}_FLAGS_${_btype} )
  endforeach()

endmacro()

#-----------------------------------------------------------------------------------------------------------------------

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
  # Ensure ECBUILD_${_flags}_FLAGS is a valid file path
  if( DEFINED ECBUILD_${_flags}_FLAGS AND NOT EXISTS ${ECBUILD_${_flags}_FLAGS} )
    ecbuild_warn( "ECBUILD_${_flags}_FLAGS points to non-existent file ${ECBUILD_${_flags}_FLAGS} and will be ignored" )
    unset( ECBUILD_${_flags}_FLAGS )
    unset( ECBUILD_${_flags}_FLAGS CACHE )
  endif()
endforeach()
if( ECBUILD_COMPILE_FLAGS )
  include( "${ECBUILD_COMPILE_FLAGS}" )
endif()

# Load default flags only if custom compilation flags not enabled
foreach( _lang C CXX Fortran )
  if( CMAKE_${_lang}_COMPILER_LOADED AND NOT (ECBUILD_SOURCE_FLAGS OR ECBUILD_COMPILE_FLAGS) )
    ecbuild_compiler_flags( ${_lang} )
  endif()
endforeach()

# Apply user or toolchain specified linker flag overrides per object type (NOT written to cache)
foreach( _btype NONE DEBUG BIT PRODUCTION RELEASE RELWITHDEBINFO )

  foreach( _obj EXE SHARED MODULE )
    if( ECBUILD_${_obj}_LINKER_FLAGS_${_btype} )
      set( CMAKE_${_obj}_LINKER_FLAGS_${_btype} ${ECBUILD_${_obj}_LINKER_FLAGS_${_btype}} )
    endif()
  endforeach()

endforeach()

#-----------------------------------------------------------------------------------------------------------------------

mark_as_advanced( CMAKE_C_FLAGS_BIT )
