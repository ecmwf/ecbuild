# (C) Copyright 1996-2012 ECMWF.
# 
# This software is licensed under the terms of the Apache Licence Version 2.0
# which can be obtained at http://www.apache.org/licenses/LICENSE-2.0. 
# In applying this licence, ECMWF does not waive the privileges and immunities 
# granted to it by virtue of its status as an intergovernmental organisation nor
# does it submit to any jurisdiction.

# macro to initialize a project

macro( ecbuild_declare_project )

    string( TOUPPER ${PROJECT_NAME} PNAME )

    # read and parse project version file
    if( EXISTS ${PROJECT_SOURCE_DIR}/VERSION.cmake )
        include( ${PROJECT_SOURCE_DIR}/VERSION.cmake )
    else()
        set( ${PROJECT_NAME}_VERSION_STR "0.0.0" )
    endif()

    string(REPLACE "." " " _version_list ${${PROJECT_NAME}_VERSION_STR} ) # dots to spaces
    
    separate_arguments( _version_list )

    list( GET _version_list 0 ${PNAME}_MAJOR_VERSION )
    list( GET _version_list 1 ${PNAME}_MINOR_VERSION )
    list( GET _version_list 2 ${PNAME}_PATCH_VERSION )

    set( ${PNAME}_VERSION "${${PNAME}_MAJOR_VERSION}.${${PNAME}_MINOR_VERSION}.${${PNAME}_PATCH_VERSION}" ) 

    # cleanup patch version of any extra qualifiers ( -dev -rc1 ... )

    string(REGEX REPLACE "^([0-9]+)\\-.*" "\\1" ${PNAME}_PATCH_VERSION "${${PNAME}_PATCH_VERSION}" )

#    debug_var( ${PNAME}_VERSION )
#    debug_var( ${PNAME}_MAJOR_VERSION )
#    debug_var( ${PNAME}_MINOR_VERSION )
#    debug_var( ${PNAME}_PATCH_VERSION )


    # if git project get its HEAD SHA1

    if( EXISTS ${PROJECT_SOURCE_DIR}/.git )
        get_git_head_revision( GIT_REFSPEC ${PNAME}_GIT_SHA1 )
    endif()

    # user defined project-specific installation paths

    set(${PNAME}_INSTALL_LIB_DIR     lib     CACHE PATH "${PNAME} installation directory for libraries")
    set(${PNAME}_INSTALL_BIN_DIR     bin     CACHE PATH "${PNAME} installation directory for executables")

    set(${PNAME}_INSTALL_INCLUDE_DIR include/${PROJECT_NAME}      CACHE PATH "${PNAME} installation directory for header files")
    set(${PNAME}_INSTALL_CMAKE_DIR   share/${PROJECT_NAME}/cmake  CACHE PATH "${PNAME} installation directory for CMake files")

    # install dirs local to this project

    set( INSTALL_BIN_DIR     ${${PNAME}_INSTALL_BIN_DIR} ) 
    set( INSTALL_LIB_DIR     ${${PNAME}_INSTALL_LIB_DIR} ) 
    set( INSTALL_INCLUDE_DIR ${${PNAME}_INSTALL_INCLUDE_DIR} ) 
    set( INSTALL_CMAKE_DIR   ${${PNAME}_INSTALL_CMAKE_DIR} ) 

    # install ecbuild configuration

    install( FILES ${CMAKE_BINARY_DIR}/ecbuild_config.h 
                   ${CMAKE_BINARY_DIR}/ecbuild_platform.h
             DESTINATION ${INSTALL_INCLUDE_DIR} )

    # print project header
    
    message( STATUS "---------------------------------------------------------" )
    
    if( DEFINED ${PNAME}_GIT_SHA1 )
        message( STATUS "[${PROJECT_NAME}] (${${PNAME}_VERSION}) [${${PNAME}_GIT_SHA1}]" )
    else()
        message( STATUS "[${PROJECT_NAME}] (${${PNAME}_VERSION})" )
    endif()

#    debug_var(INSTALL_BIN_DIR)
#    debug_var(INSTALL_LIB_DIR)
#    debug_var(INSTALL_INCLUDE_DIR)
#    debug_var(INSTALL_CMAKE_DIR)
    
    set( ECBUILD_PROJECTS ${ECBUILD_PROJECTS} ${PROJECT_NAME} CACHE INTERNAL "list of (sub)projects" )

endmacro( ecbuild_declare_project )

