# SPDX-FileCopyrightText: 2011- European Centre for Medium-Range Weather Forecasts (ECMWF)
# SPDX-License-Identifier: Apache-2.0

function( ecbuild_target_fortran_module_directory )
  set( options NO_MODULE_DIRECTORY )
  set( single_value_args TARGET MODULE_DIRECTORY INSTALL_MODULE_DIRECTORY )
  set( multi_value_args "" )
  cmake_parse_arguments( _PAR "${options}" "${single_value_args}" "${multi_value_args}"  ${_FIRST_ARG} ${ARGN} )

  if( NOT _PAR_TARGET )
    ecbuild_critical( "Missing argument TARGET" )
  endif()

  if( _PAR_NO_MODULE_DIRECTORY )
    set_target_properties( ${_PAR_TARGET} PROPERTIES Fortran_MODULE_DIRECTORY "" )
  else()
    if( NOT _PAR_MODULE_DIRECTORY )
      ecbuild_critical( "Missing argument MODULE_DIRECTORY" )
    endif()
    set_target_properties( ${_PAR_TARGET} PROPERTIES Fortran_MODULE_DIRECTORY ${_PAR_MODULE_DIRECTORY} )
    target_include_directories( ${_PAR_TARGET} PUBLIC $<BUILD_INTERFACE:${_PAR_MODULE_DIRECTORY}> )
  endif()

  if( ECBUILD_INSTALL_FORTRAN_MODULES )
    if( _PAR_INSTALL_MODULE_DIRECTORY )
      target_include_directories( ${_PAR_TARGET} PUBLIC $<INSTALL_INTERFACE:${_PAR_INSTALL_MODULE_DIRECTORY}> )
      install( DIRECTORY ${_PAR_MODULE_DIRECTORY}/
               DESTINATION ${_PAR_INSTALL_MODULE_DIRECTORY}
               COMPONENT modules )
    endif()
  endif()

endfunction()
