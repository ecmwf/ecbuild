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
    
    include( ${PROJECT_SOURCE_DIR}/VERSION.cmake )

    string(REPLACE "." " " _version_list ${${PROJECT_NAME}_VERSION_STR} ) # dots to spaces
    
    separate_arguments( _version_list )

    list( GET _version_list 0 ${PNAME}_MAJOR_VERSION )
    list( GET _version_list 1 ${PNAME}_MINOR_VERSION )
    list( GET _version_list 2 ${PNAME}_PATCH_VERSION )

    set( ${PNAME}_VERSION "${${PNAME}_MAJOR_VERSION}.${${PNAME}_MINOR_VERSION}.${${PNAME}_PATCH_VERSION}" ) 

    # cleanup patch version of any extra qualifiers ( -dev -rc1 ... )

    string(REGEX REPLACE "^([0-9]+)\\-.*" "\\1" ${PNAME}_PATCH_VERSION "${${PNAME}_PATCH_VERSION}" )

    debug_var( ${PNAME}_VERSION )
    debug_var( ${PNAME}_MAJOR_VERSION )
    debug_var( ${PNAME}_MINOR_VERSION )
    debug_var( ${PNAME}_PATCH_VERSION )

    # print project header
    
    message( STATUS "---------------------------------------------------------" )
    
    message( STATUS "[${PROJECT_NAME}] (${${PNAME}_VERSION})" )
    
    set( ECMWF_PROJECTS ${ECMWF_PROJECTS} ${PROJECT_NAME} CACHE INTERNAL "list of (sub)projects" )

endmacro( ecbuild_declare_project )

