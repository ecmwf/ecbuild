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
# ecbuild_find_package_search_hints
# =================================
#
# Detect more search hints and possibly add to <name>_ROOT ::
#
#   ecbuild_find_package_search_hints( NAME <name> )
#
# This is called within ecbuild_find_package().
# Alternatively it can be called anywhere before a standard find_package()
#
# Motivation
# ----------
#
# Since CMake 3.12 the recommended approach to find_package is via <name>_ROOT
# which can be set both as variable or in the environment.
# Many environments still need to be adapted to this, as they are set up with the
# ecbuild 2 convention <name>_PATH or <NAME>_PATH. Furthermore this allows compatibility
# with <name>_ROOT for CMake versions < 3.12
#
# Procedure
# ---------
#
# 1) If neither <name>_ROOT nor <name>_DIR are set in scope:
#      Try setting <name>_ROOT variable to first valid in list [ <name>_PATH ; <NAME>_PATH ]
#
# 2) If 1) was not succesfull and neither <name>_ROOT nor <name>_DIR are set in environment:
#      Try setting <name>_ROOT variable to first valid in list [ ENV{<name>_PATH} ; ENV{<NAME>_PATH} ]
#
# 3) Overcome CMake versions < 3.12 that do not yet recognize <name>_ROOT in scope or environment
#      If CMake version < 3.12:
#        If <name>_DIR not defined in scope or environment, but <name>_ROOT IS defined in scope or environment
#           Try setting <name>_DIR to a valid cmake-dir deduced from <name>_ROOT.
#           Warning: Deduction is not feature-complete (it could be improved, but should now cover 99% of cases)
#                    It is advised to use CMake 3.12 instead.
#
##############################################################################

function( ecbuild_find_package_search_hints )
  set( options )
  set( single_value_args NAME )
  set( multi_value_args )

  cmake_parse_arguments( _PAR "${options}" "${single_value_args}" "${multi_value_args}"  ${_FIRST_ARG} ${ARGN} )

  if( NOT DEFINED _PAR_NAME )
    ecbuild_critical( "ecbuild_find_package_search_hints(): NAME argument is missing" )
  endif()

  string( TOUPPER ${_PAR_NAME} pkgUPPER )
  unset( _outvar )
  unset( _names )
  # Diagnose what is there for debugging
  list( APPEND _names ${_PAR_NAME} )
  if( NOT ${pkgUPPER} STREQUAL ${_PAR_NAME} )
    list( APPEND _names ${pkgUPPER} )
  endif()
  foreach( _suffix DIR ROOT HOME PATH ROOT_DIR )
    foreach( _name ${_names})
      if( DEFINED ${_name}_${_suffix} )
        list( APPEND _outvar "${_name}_${_suffix}: ${${_name}_${_suffix}}")
      endif()
      if( DEFINED ENV{${_name}_${_suffix}} )
        list( APPEND _outvar "ENV{${_name}_${_suffix}}: $ENV{${_name}_${_suffix}}")
      endif()
    endforeach()
  endforeach()
  if( DEFINED CMAKE_PREFIX_PATH )
    list( APPEND _outvar "CMAKE_PREFIX_PATH: ${CMAKE_PREFIX_PATH}")
  endif()
  if( DEFINED ENV{CMAKE_PREFIX_PATH}  )
    list( APPEND _outvar "ENV{CMAKE_PREFIX_PATH}: $ENV{CMAKE_PREFIX_PATH}")
  endif()

  if( _outvar )
    string( REPLACE ";" "\n             - " print_this "${_outvar}" )
    ecbuild_debug( "ecbuild_find_package_search_hints(${_PAR_NAME}): Detected variables that could influence find_package() :\n             - ${print_this}" )
  endif()

  # Only look at older variables <name>_PATH and <NAME>_PATH if <name>_ROOT and <name>_DIR are not defined in scope
  if( NOT DEFINED ${_PAR_NAME}_ROOT AND NOT DEFINED ${_PAR_NAME}_DIR )
    if( NOT DEFINED ${_PAR_NAME}_ROOT AND DEFINED ${_PAR_NAME}_PATH )
      ecbuild_debug("ecbuild_find_package_search_hints(${_PAR_NAME}): Setting ${_PAR_NAME}_ROOT to ${_PAR_NAME}_PATH: ${${_PAR_NAME}_PATH}")
      set( ${_PAR_NAME}_ROOT ${${_PAR_NAME}_PATH} )
    endif()
    if( NOT DEFINED ${_PAR_NAME}_ROOT AND DEFINED ${pkgUPPER}_PATH )
      ecbuild_debug("ecbuild_find_package_search_hints(${_PAR_NAME}): Setting ${_PAR_NAME}_ROOT to ${pkgUPPER}_PATH: ${${pkgUPPER}_PATH}")
      set( ${_PAR_NAME}_ROOT ${${pkgUPPER}_PATH} )
    endif()
    if( DEFINED ${_PAR_NAME}_ROOT )
      set( ${_PAR_NAME}_ROOT ${${_PAR_NAME}_ROOT} PARENT_SCOPE )
    endif()
  endif()
  # Only look at older variables ENV{<name>_PATH} and ENV{<NAME>_PATH} if <name>_ROOT and <name>_DIR are not defined in scope or in environment
  if( NOT DEFINED ${_PAR_NAME}_ROOT AND NOT DEFINED ENV{${_PAR_NAME}_ROOT} AND
      NOT DEFINED ${_PAR_NAME}_DIR  AND NOT DEFINED ENV{${_PAR_NAME}_DIR} )
      if( NOT DEFINED ${_PAR_NAME}_ROOT AND DEFINED ENV{${_PAR_NAME}_PATH} )
        ecbuild_debug("ecbuild_find_package_search_hints(${_PAR_NAME}): Setting ${_PAR_NAME}_ROOT to ENV{${_PAR_NAME}_PATH}: $ENV{${_PAR_NAME}_PATH}")
        set( ${_PAR_NAME}_ROOT $ENV{${_PAR_NAME}_PATH} )
      endif()
      if( NOT DEFINED ${_PAR_NAME}_ROOT AND DEFINED ENV{${pkgUPPER}_PATH} )
        ecbuild_debug("ecbuild_find_package_search_hints(${_PAR_NAME}): Setting ${_PAR_NAME}_ROOT to ENV{${pkgUPPER}_PATH}: $ENV{${pkgUPPER}_PATH}")
        set( ${_PAR_NAME}_ROOT $ENV{${pkgUPPER}_PATH} )
      endif()
      if( DEFINED ${_PAR_NAME}_ROOT )
        set( ${_PAR_NAME}_ROOT ${${_PAR_NAME}_ROOT} PARENT_SCOPE )
      endif()
  endif()

  #### Overcome CMake 3.11 to 3.12 transition with <Package>_ROOT
  #    warning! this is not fully foolproof!
  if( CMAKE_VERSION VERSION_LESS 3.12 )
    if( ( NOT DEFINED ${_PAR_NAME}_DIR  AND NOT DEFINED ENV{${_PAR_NAME}_DIR}   ) AND
        (     DEFINED ${_PAR_NAME}_ROOT OR      DEFINED ENV{${_PAR_NAME}_ROOT}} ) )

      if( DEFINED ${_PAR_NAME}_ROOT )
        set( _root ${_PAR_NAME}_ROOT )
      else()
        set( _root $ENV{${_PAR_NAME}_ROOT} )
      endif()
      foreach( _path_suffix   lib/cmake/${_PAR_NAME}
                              share/${_PAR_NAME}/cmake )
        if( EXISTS ${_root}/${_path_suffix} )
          ecbuild_debug("ecbuild_find_package_search_hints(${_PAR_NAME}): Setting ${_PAR_NAME}_DIR to ${_root}/${_path_suffix}")
          set( ${_PAR_NAME}_DIR ${_root}/${_path_suffix} PARENT_SCOPE )
          break()
        endif()
      endforeach()
    endif()
  endif()

endfunction()
