# (C) Copyright 1996-2015 ECMWF.
#
# This software is licensed under the terms of the Apache Licence Version 2.0
# which can be obtained at http://www.apache.org/licenses/LICENSE-2.0.
# In applying this licence, ECMWF does not waive the privileges and immunities
# granted to it by virtue of its status as an intergovernmental organisation nor
# does it submit to any jurisdiction.

macro( ecbuild_compiler_flags _lang )

  if( CMAKE_${_lang}_COMPILER_LOADED )

    ecbuild_debug( "try include ${ECBUILD_MACROS_DIR}/compiler_flags/${CMAKE_${_lang}_COMPILER_ID}_${_lang}.cmake ")

    include( ${ECBUILD_MACROS_DIR}/compiler_flags/${CMAKE_${_lang}_COMPILER_ID}_${_lang}.cmake OPTIONAL )

    ecbuild_debug_var( CMAKE_${_lang}_FLAGS )

    foreach( _btype NONE DEBUG BIT PRODUCTION RELEASE RELWITHDEBINFO )
      ecbuild_debug_var( CMAKE_${_lang}_FLAGS_${_btype} )
    endforeach()

  endif()

  foreach( _btype NONE DEBUG BIT PRODUCTION RELEASE RELWITHDEBINFO )
    if( DEFINED ECBUILD_${_lang}_FLAGS_${_btype} )
      set( CMAKE_${_lang}_FLAGS_${_btype} ${ECBUILD_${_lang}_FLAGS_${_btype}} )
    endif()
    mark_as_advanced( CMAKE_${_lang}_FLAGS_${_btype} )
  endforeach()

  if( DEFINED ECBUILD_${_lang}_FLAGS )
    set( CMAKE_${_lang}_FLAGS "${ECBUILD_${_lang}_FLAGS}" )
  endif()

  mark_as_advanced( CMAKE_${_lang}_FLAGS )

  if( DEFINED ECBUILD_${_lang}_LINK_FLAGS )
    set( CMAKE_${_lang}_LINK_FLAGS "${ECBUILD_${_lang}_LINK_FLAGS}" )
  endif()

  mark_as_advanced( CMAKE_${_lang}_LINK_FLAGS )

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