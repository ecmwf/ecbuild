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

    set( options REQUIRED QUIET EXACT )
    set( single_value_args PROJECT NAME VERSION )
    set( multi_value_args )

    cmake_parse_arguments( _PAR "${options}" "${single_value_args}" "${multi_value_args}"  ${_FIRST_ARG} ${ARGN} )

    if(_PAR_UNPARSED_ARGUMENTS)
      message(FATAL_ERROR "Unknown keywords given to ecbuild_use_package(): \"${_PAR_UNPARSED_ARGUMENTS}\"")
    endif()

    if( NOT _PAR_PROJECT  )
      message(FATAL_ERROR "The call to ecbuild_use_package() doesn't specify the PROJECT.")
    endif()

    if( _PAR_EXACT AND NOT _PAR_VERSION )
      message(FATAL_ERROR "Call to ecbuild_use_package() requests EXACT but doesn't specify VERSION.")
    endif()    

    set( _package_name ${_PAR_PROJECT} )
    if( _PAR_NAME  )
        set( _package_name ${_PAR_NAME} )
    endif()

    # try to find the package as a subproject and build it

    ecbuild_add_subproject( ${_PAR_PROJECT} )

    # subproject not found, so try to find precompiled binaries or a build tree

    string( TOUPPER ${_PAR_PROJECT} PNAME )

    if( NOT DEFINED ${PNAME}_SUBPROJ_DIR ) 
    
        set( _${PNAME}_opts "" )
        set( _${PNAME}_version "" )

        if( _PAR_REQUIRED )
            list( APPEND _${PNAME}_opts "REQUIRED" )
        endif()
        if( _PAR_QUIET )
            list( APPEND _${PNAME}_opts "QUIET" )
        endif()
        
        if( _PAR_VERSION )
            set( _${PNAME}_version ${_PAR_VERSION} )
            if( _PAR_EXACT )
                set( _${PNAME}_version ${_PAR_VERSION} EXACT )
            endif()
        endif()

        find_package( ${_package_name} ${_${PNAME}_version} ${_${PNAME}_opts} )

    endif()

endmacro()
