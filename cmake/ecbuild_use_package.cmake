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

    set( options            REQUIRED QUIET EXACT )
    set( single_value_args  PROJECT VERSION )
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

    message( STATUS "---------------------------------------------------------" )

    # try to find the package as a subproject and build it

    string( TOUPPER ${_PAR_PROJECT} PNAME )

    # user defined dir with subprojects

    if( NOT DEFINED ${PNAME}_SOURCE AND DEFINED SUBPROJECT_DIRS )
        foreach( dir ${SUBPROJECT_DIRS} )
            if( EXISTS ${dir}/${_PAR_PROJECT} AND EXISTS ${dir}/${_PAR_PROJECT}/CMakeLists.txt )
                set( ${PNAME}_SOURCE "${dir}/${_PAR_PROJECT}" )
            endif()
        endforeach()
    endif()

    # user defined path to subproject

    if( DEFINED ${PNAME}_SOURCE )

        if( NOT EXISTS ${${PNAME}_SOURCE} OR NOT EXISTS ${${PNAME}_SOURCE}/CMakeLists.txt )
            message( FATAL_ERROR "User defined source directory '${${PNAME}_SOURCE}' for project '${_PAR_PROJECT}' does not exist or does not contain a CMakeLists.txt file." )
        endif()

        set( ${PNAME}_SUBPROJ_DIR "${${PNAME}_SOURCE}" )

    else() # default is 'dropped in' subdirectory named as project

        if( EXISTS ${CMAKE_CURRENT_SOURCE_DIR}/${_PAR_PROJECT} AND EXISTS ${CMAKE_CURRENT_SOURCE_DIR}/${_PAR_PROJECT}/CMakeLists.txt )
            set( ${PNAME}_SUBPROJ_DIR "${CMAKE_CURRENT_SOURCE_DIR}/${_PAR_PROJECT}" )
        endif()

    endif()

    # check if was already added as subproject ...

    set( _just_added 0 )
    set( _do_version_check 0 )
    set( _source_description "" )

    list( FIND ECBUILD_PROJECTS ${_PAR_PROJECT} _ecbuild_project_${PNAME} )

    if( NOT _ecbuild_project_${PNAME} EQUAL "-1" )
        set( ${PNAME}_PREVIOUS_SUBPROJECT 1 )
    else()
        set( ${PNAME}_PREVIOUS_SUBPROJECT 0 )
    endif()

    # solve capitalization issues
    
    if( ${_PAR_PROJECT}_FOUND AND NOT ${PNAME}_FOUND )
        set( ${PNAME}_FOUND 1 ) 
    endif()
    if( ${PNAME}_FOUND AND NOT ${_PAR_PROJECT}_FOUND )
        set( ${_PAR_PROJECT}_FOUND 1 ) 
    endif()

    # Case 1) project was NOT added as subproject and is NOT FOUND

    if( NOT ${PNAME}_FOUND AND NOT ${PNAME}_PREVIOUS_SUBPROJECT )

            # check if SUBPROJDIR is set

            if( DEFINED ${PNAME}_SUBPROJ_DIR )

                # check version is acceptable
                set( _just_added 1 )
                set( _do_version_check 1 )
                set( _source_description "sub-project ${_PAR_PROJECT} (sources)" )

                # add as a subproject

                set( ${PNAME}_SUBPROJ_DIR ${${PNAME}_SUBPROJ_DIR} CACHE PATH "Path to ${_PAR_PROJECT} source directory" )

                set( ECBUILD_PROJECTS ${ECBUILD_PROJECTS} ${_PAR_PROJECT} CACHE INTERNAL "" )

                add_subdirectory( ${${PNAME}_SUBPROJ_DIR} ${_PAR_PROJECT} )

                set( ${PNAME}_FOUND 1 )
                set( ${_PAR_PROJECT}_VERSION ${${PNAME}_VERSION} )

            endif()

    endif()

    # Case 2) project was already added as subproject, so is already FOUND -- BUT must check version acceptable

    if( ${PNAME}_PREVIOUS_SUBPROJECT )

        if( NOT ${PNAME}_FOUND )
            message( FATAL_ERROR "${_PAR_PROJECT} was already included as sub-project but ${PNAME}_FOUND isn't set -- this is likely a BUG in ecbuild" )
        endif()

        # check version is acceptable
        set( _do_version_check 1 )
        set( _source_description "already existing sub-project ${_PAR_PROJECT} (sources)" )

    endif()

    # Case 3) project was NOT added as subproject, but is FOUND -- so it was previously found as a binary ( either build or install tree )

    if( ${PNAME}_FOUND AND NOT ${PNAME}_PREVIOUS_SUBPROJECT AND NOT _just_added )

        # check version is acceptable
        set( _do_version_check 1 )
        set( _source_description "previously found package ${_PAR_PROJECT} (binaries)" )

    endif()

    # test version for Cases 1,2,3

    # debug_var( _PAR_PROJECT )
    # debug_var( _PAR_VERSION )
    # debug_var( _just_added )
    # debug_var( ${PNAME}_FOUND )
    # debug_var( ${PNAME}_PREVIOUS_SUBPROJECT )

    if( _PAR_VERSION AND _do_version_check )
            if( _PAR_EXACT )
                if( NOT ${_PAR_PROJECT}_VERSION VERSION_EQUAL _PAR_VERSION )
                    message( FATAL_ERROR "${PROJECT_NAME} requires (exactly) ${_PAR_PROJECT} = ${_PAR_VERSION} -- detected as ${_source_description} ${${_PAR_PROJECT}_VERSION}" )
                endif()
            else()
				if( _PAR_VERSION VERSION_LESS ${_PAR_PROJECT}_VERSION OR _PAR_VERSION VERSION_EQUAL ${_PAR_PROJECT}_VERSION )
                    message( STATUS "${PROJECT_NAME} requires ${_PAR_PROJECT} >= ${_PAR_VERSION} -- detected as ${_source_description} ${${_PAR_PROJECT}_VERSION}" )
				else()
                    message( FATAL_ERROR "${PROJECT_NAME} requires ${_PAR_PROJECT} >= ${_PAR_VERSION} -- detected only ${_source_description} ${${_PAR_PROJECT}_VERSION}" )
                endif()
            endif()
    endif()

    # Case 4) is NOT FOUND so far, NOT as sub-project (now or before), and NOT as binary neither 
    #         so try to find precompiled binaries or a build tree

    if( NOT ${PNAME}_FOUND )

        set( _opts )
        if( _PAR_VERSION )
            list( APPEND _opts VERSION ${_PAR_VERSION} )
        endif()
        if( _PAR_EXACT )
            list( APPEND _opts EXACT )
        endif()
        if( _PAR_REQUIRED )
            list( APPEND _opts REQUIRED )
        endif()
    
        ecbuild_find_package( NAME ${_PAR_PROJECT} ${_opts} )

        if( ${_PAR_PROJECT}_FOUND )

            set( ${PNAME}_FOUND ${${_PAR_PROJECT}_FOUND} )

            message( STATUS "[${_PAR_PROJECT}] (${${_PAR_PROJECT}_VERSION})" )

            message( STATUS "   ${PNAME}_INCLUDE_DIRS : [${${PNAME}_INCLUDE_DIRS}]" )
            if( ${PNAME}_DEFINITIONS )
                message( STATUS "   ${PNAME}_DEFINITIONS : [${${PNAME}_DEFINITIONS}]" )
            endif()
            message( STATUS "   ${PNAME}_LIBRARIES : [${${PNAME}_LIBRARIES}]" )

        endif()

    endif()

endmacro()
