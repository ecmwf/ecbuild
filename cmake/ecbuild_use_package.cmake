# (C) Copyright 1996-2012 ECMWF.
# 
# This software is licensed under the terms of the Apache Licence Version 2.0
# which can be obtained at http://www.apache.org/licenses/LICENSE-2.0. 
# In applying this licence, ECMWF does not waive the privileges and immunities 
# granted to it by virtue of its status as an intergovernmental organisation nor
# does it submit to any jurisdiction.

##############################################################################
# macro for adding a subproject directory
##############################################################################

macro( ecbuild_use_package )

    set( options REQUIRED QUIET )
    set( single_value_args PROJECT NAME )
    set( multi_value_args )

    cmake_parse_arguments( _PAR "${options}" "${single_value_args}" "${multi_value_args}"  ${_FIRST_ARG} ${ARGN} )

    if(_PAR_UNPARSED_ARGUMENTS)
      message(FATAL_ERROR "Unknown keywords given to ecbuild_use_package(): \"${_PAR_UNPARSED_ARGUMENTS}\"")
    endif()

    if( NOT _PAR_PROJECT  )
      message(FATAL_ERROR "The call to ecbuild_use_package() doesn't specify the PROJECT.")
    endif()

    string( TOUPPER ${_PAR_PROJECT} PNAME )

    if( DEFINED _PAR_NAME  )
        set( _package_name ${_PAR_NAME} )
    else()
        set( _package_name ${_PNAME} )
    endif()

    # try to find the package as a subproject and build it

    ecbuild_add_subproject( ${_PAR_PROJECT} )

    # subproject not found, so try to find precompiled binaries

    if( NOT DEFINED ${PNAME}_SUBPROJ_DIR ) 
    
        set( _${PNAME}_find_opts "" )
        if( DEFINED _PAR_REQUIRED )
            list( APPEND _${PNAME}_find_opts "REQUIRED" )
        endif()
        if( DEFINED _PAR_QUIET )
            list( APPEND _${PNAME}_find_opts "QUIET" )
        endif()

        find_package( ${_package_name} ${_${PNAME}_find_opts} )

    endif()

endmacro()
