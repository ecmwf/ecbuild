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
    
    set( three_part_version_regex "([0-9]+)\\.([0-9]+)\\.([0-9]+)")
    set( four_part_version_regex  "([0-9]+)\\.([0-9]+)\\.([0-9]+)-([a-zA-Z0-9]+)")
    include( ${PROJECT_SOURCE_DIR}/VERSION.cmake )

    set( ${PNAME}_VERSION_STR ${${PROJECT_NAME}_VERSION_STR} )

    set( vregex "" )
    if( ${PNAME}_VERSION_STR MATCHES ${four_part_version_regex} )
        set( vregex ${four_part_version_regex} )
    else()
        if( ${PNAME}_VERSION_STR MATCHES ${three_part_version_regex} )
            set( vregex ${three_part_version_regex} )
        else()
            message( FATAL_ERROR "project ${PROJECT_NAME} has  unsuported version formating in ${PROJECT_SOURCE_DIR}/VERSION.cmake -- allowed format is [0-9]+.[0-9]+.[0-9]+(-[a-zA-Z0-9]+)" )
        endif()
    endif()

    string( REGEX REPLACE ${vregex} "\\1"  ${PNAME}_MAJOR_VERSION ${${PNAME}_VERSION_STR} )
    string( REGEX REPLACE ${vregex} "\\2"  ${PNAME}_MINOR_VERSION ${${PNAME}_VERSION_STR} )
    string( REGEX REPLACE ${vregex} "\\3"  ${PNAME}_PATCH_VERSION ${${PNAME}_VERSION_STR} )

    set( ${PNAME}_VERSION "${${PNAME}_MAJOR_VERSION}.${${PNAME}_MINOR_VERSION}.${${PNAME}_PATCH_VERSION}" )

    if( ${PNAME}_VERSION_STR MATCHES ${four_part_version_regex} )
        string( REGEX REPLACE ${vregex} "\\4"  ${PNAME}_EXTRA_VERSION ${${PNAME}_VERSION_STR} )
        set( ${PNAME}_VERSION "${${PNAME}_VERSION}-${${PNAME}_EXTRA_VERSION}" )
    else()
        set( ${PNAME}_EXTRA_VERSION "" )
    endif()    

    # print project header
    
    message( STATUS "---------------------------------------------------------" )
    
    message( STATUS "[${PROJECT_NAME}] (${${PNAME}_VERSION})" )
    
    set( ECMWF_PROJECTS ${ECMWF_PROJECTS} ${PROJECT_NAME} CACHE INTERNAL "list of (sub)projects" )

endmacro( ecbuild_declare_project )

