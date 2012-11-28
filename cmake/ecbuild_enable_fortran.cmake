# (C) Copyright 1996-2012 ECMWF.
#
# This software is licensed under the terms of the Apache Licence Version 2.0
# which can be obtained at http://www.apache.org/licenses/LICENSE-2.0.
# In applying this licence, ECMWF does not waive the privileges and immunities
# granted to it by virtue of its status as an intergovernmental organisation nor
# does it submit to any jurisdiction.

##############################################################################
# macro for enablignthe fortan language

macro( ecbuild_enable_fortran )

    set( options REQUIRED  )
    set( single_value_args MODULE_DIRECTORY )
    set( multi_value_args  )

    cmake_parse_arguments( _PAR "${options}" "${single_value_args}" "${multi_value_args}"  ${_FIRST_ARG} ${ARGN} )

    if(_PAR_UNPARSED_ARGUMENTS)
      message(FATAL_ERROR "Unknown keywords given to ecbuild_enable_fortran(): \"${_PAR_UNPARSED_ARGUMENTS}\"")
    endif()

  enable_language( Fortran )

  if( DEFINED __PAR_REQUIRED )
      if( NOT CMAKE_Fortran_COMPILER OR NOT CMAKE_Fortran_COMPILER_WORKS )
          message( FATAL_ERROR "Fortran compiler required by project ${PROJECT_NAME} but does not seem to work" )
      endif()
  endif()

  if( CMAKE_Fortran_COMPILER_LOADED )
    include(CheckFortranFunctionExists)
    include(FortranCInterface)
  endif()

  if( DEFINED _PAR_MODULE_DIRECTORY )
    set( CMAKE_Fortran_MODULE_DIRECTORY  ${_PAR_MODULE_DIRECTORY} CACHE PATH "directory for all fortran modules." )
  else()
    set( CMAKE_Fortran_MODULE_DIRECTORY  ${PROJECT_BINARY_DIR}/include CACHE PATH "directory for all fortran modules." )
  endif()

  install( CODE "EXECUTE_PROCESS (COMMAND \"${CMAKE_COMMAND}\" -E copy_directory \"${CMAKE_Fortran_MODULE_DIRECTORY}/\${BUILD_TYPE}\" \"${CMAKE_INSTALL_PREFIX}/include\")" )

endmacro( ecbuild_enable_fortran )