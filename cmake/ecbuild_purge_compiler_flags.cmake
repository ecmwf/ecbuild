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
# ecbuild_get_build_type_list
# ===========================
#
# Return the list of recognised CMake build types ::
#
#   ecbuild_get_build_type_list( <outvar> )
#
# The list contains the standard ecBuild build types
# (``NONE``, ``DEBUG``, ``BIT``, ``PRODUCTION``, ``RELEASE``,
# ``RELWITHDEBINFO``) plus the value of ``CMAKE_BUILD_TYPE`` if it is set
# to a custom value not already in the list.
#
##############################################################################

macro( ecbuild_get_build_type_list _outvar )
  set( _btypelist NONE DEBUG BIT PRODUCTION RELEASE RELWITHDEBINFO )

  if (NOT "${CMAKE_BUILD_TYPE}" IN_LIST _btypelist)
    list (APPEND _btypelist "${CMAKE_BUILD_TYPE}")
  endif ()

  set( ${_outvar} ${_btypelist} )
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

    ecbuild_get_build_type_list( _btypelist )
    list( REMOVE_ITEM _btypelist NONE )
    list( INSERT _btypelist 0 ALL )

    cmake_parse_arguments( _PAR "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN} )

    if( CMAKE_${_lang}_COMPILER_LOADED )

      # Clear default compilation flags potentially inherited from parent scope
      # when using custom compilation flags
      set(CMAKE_${_lang}_FLAGS "")
      foreach( _btype IN LISTS _btypelist)
        set(CMAKE_${_lang}_FLAGS_${_btype} "")
      endforeach()

    endif()

    if( _PAR_WARN )
      ecbuild_warn( "Purging compiler flags set for ${_lang}" )
    endif()

endmacro()
