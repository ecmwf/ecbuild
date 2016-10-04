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

  # Set compiler and language specific default flags
  if( CMAKE_${_lang}_COMPILER_LOADED )
    ecbuild_debug( "ecbuild_compiler_flags(${_lang}): try include ${ECBUILD_MACROS_DIR}/compiler_flags/${CMAKE_${_lang}_COMPILER_ID}_${_lang}.cmake ")
    include( ${ECBUILD_MACROS_DIR}/compiler_flags/${CMAKE_${_lang}_COMPILER_ID}_${_lang}.cmake OPTIONAL )
  endif()

  # Apply user or toolchain specified overrides

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

### OVERRIDE Compiler FLAGS (we override because CMake forcely defines them) -- see ecbuild_compiler_flags() macro

foreach( _lang C CXX Fortran )
  if( CMAKE_${_lang}_COMPILER_LOADED )
    ecbuild_compiler_flags( ${_lang} )
  endif()
endforeach()

### OVERRIDE Linker FLAGS per object type (we override because CMake forcely defines them)

foreach( _btype NONE DEBUG BIT PRODUCTION RELEASE RELWITHDEBINFO )

  foreach( _obj EXE SHARED MODULE )
    if( ECBUILD_${_obj}_LINKER_FLAGS_${_btype} )
      set( CMAKE_${_obj}_LINKER_FLAGS_${_btype} ${ECBUILD_${_obj}_LINKER_FLAGS_${_btype}} )
    endif()
  endforeach()

endforeach()

#-----------------------------------------------------------------------------------------------------------------------

mark_as_advanced( CMAKE_C_FLAGS_BIT )
