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

macro( ecbuild_find_package )

    set( options REQUIRED QUIET EXACT )
    set( single_value_args NAME VERSION )
    set( multi_value_args )

    cmake_parse_arguments( _PAR "${options}" "${single_value_args}" "${multi_value_args}"  ${_FIRST_ARG} ${ARGN} )

    if(_PAR_UNPARSED_ARGUMENTS)
      message(FATAL_ERROR "Unknown keywords given to ecbuild_find_package(): \"${_PAR_UNPARSED_ARGUMENTS}\"")
    endif()

    if( NOT _PAR_NAME  )
      message(FATAL_ERROR "The call to ecbuild_find_package() doesn't specify the NAME.")
    endif()

    if( _PAR_EXACT AND NOT _PAR_VERSION )
      message(FATAL_ERROR "Call to ecbuild_find_package() requests EXACT but doesn't specify VERSION.")
    endif()

    # debug_var( _PAR_NAME )

    string( TOUPPER ${_PAR_NAME} PNAME )

    set( _${PNAME}_version "" )
    if( _PAR_VERSION )
        set( _${PNAME}_version ${_PAR_VERSION} )
        if( _PAR_EXACT )
            set( _${PNAME}_version ${_PAR_VERSION} EXACT )
        endif()
    endif()

    set( _quiet )
    if( _PAR_QUIET )
        set( _quiet QUIET )
    endif()

    # paths @ ECMWF
    set( _ecmwf_paths )
    if( EXISTS /usr/local/lib/metaps/lib/${_PAR_NAME} )
        file( GLOB _ecmwf_paths_metaps "/usr/local/lib/metaps/lib/${_PAR_NAME}/*" ) 
        list( APPEND _ecmwf_paths ${_ecmwf_paths_metaps} )
    endif()
    if( EXISTS /usr/local/apps/${_PAR_NAME} )
        file( GLOB _ecmwf_paths_apps "/usr/local/apps/${_PAR_NAME}/*" ) 
        list( APPEND _ecmwf_paths ${_ecmwf_paths_apps} )
    endif()

    # check environment variable
    if( NOT ${PNAME}_PATH AND NOT "$ENV{${PNAME}_PATH}" STREQUAL "" )
        set( ${PNAME}_PATH "$ENV{${PNAME}_PATH}" )
    endif()

    # search user defined paths first
    if( ${_PAR_NAME}_PATH OR ${PNAME}_PATH OR _ecmwf_paths )

        if( NOT ${_PAR_NAME}_FOUND )
            find_package( ${_PAR_NAME} ${_${PNAME}_version} QUIET NO_MODULE PATHS ${${_PAR_NAME}_PATH} ${${PNAME}_PATH} ${_ecmwf_paths} NO_DEFAULT_PATH )
        endif()

        if( NOT ${_PAR_NAME}_FOUND )
            find_package( ${_PAR_NAME} ${_${PNAME}_version} QUIET PATHS ${${_PAR_NAME}_PATH} ${${PNAME}_PATH} ${_ecmwf_paths} NO_DEFAULT_PATH )
        endif()
    
    endif()

    # search system paths

    if( NOT ${_PAR_NAME}_FOUND )
        find_package( ${_PAR_NAME} ${_${PNAME}_version} ${_quiet} NO_MODULE)
    endif()

    if( NOT ${_PAR_NAME}_FOUND )
        find_package( ${_PAR_NAME} ${_${PNAME}_version} ${_quiet} )
    endif()

    # check version ...

    if( ${_PAR_NAME}_FOUND )
        set( _version_acceptable 1 )
        if( _PAR_VERSION )
            if( ${_PAR_NAME}_VERSION )
                if( _PAR_EXACT )
                    if( NOT ${_PAR_NAME}_VERSION VERSION_EQUAL _PAR_VERSION )
                        message( STATUS "${PROJECT_NAME} requires (exactly) ${_PAR_NAME} = ${_PAR_VERSION} -- found ${${_PAR_NAME}_VERSION}" )
                        set( _version_acceptable 0 )
                    endif()
                else()
                    if( _PAR_VERSION VERSION_LESS ${_PAR_NAME}_VERSION OR _PAR_VERSION VERSION_EQUAL ${_PAR_NAME}_VERSION )
                        set( _version_acceptable 1 )
                    else()
                        message( WARNING "${PROJECT_NAME} requires ${_PAR_NAME} >= ${_PAR_VERSION} -- found ${${_PAR_NAME}_VERSION}" )
                        set( _version_acceptable 0 )
                    endif()
                endif()
            else()
                message( WARNING "${PROJECT_NAME} found ${_PAR_NAME} but no version information, so cannot check if satisfies ${_PAR_VERSION}" )
                set( _version_acceptable 0 )
            endif()
        endif()
    endif()

    if( ${_PAR_NAME}_FOUND )

        if( _version_acceptable )
            set( ${PNAME}_FOUND ${${_PAR_NAME}_FOUND} )
        else()
            set( ${PNAME}_FOUND 0 )
            set( ${_PAR_NAME}_FOUND 0 )
        endif()

    endif()

    if( NOT ${_PAR_NAME}_FOUND AND _PAR_REQUIRED )
            message( FATAL_ERROR "${PROJECT_NAME} requires package ${_PAR_NAME} but no suitable version was found" )
    endif()

endmacro()
