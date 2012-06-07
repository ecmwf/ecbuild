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

macro( ecbuild_add_subproject PROJ_NAME )

    string( TOUPPER ${PROJ_NAME} PNAME )

    # user defined dir with subprojects

    if( NOT DEFINED ${PNAME}_SOURCE AND DEFINED SUBPROJECT_DIRS )
        foreach( dir ${SUBPROJECT_DIRS} )
            if( EXISTS ${dir}/${PROJ_NAME} AND EXISTS ${dir}/${PROJ_NAME}/CMakeLists.txt )
                set( ${PNAME}_SOURCE "${dir}/${PROJ_NAME}" )
            endif()
        endforeach()
    endif()

    # user defined path to subproject

    if( DEFINED ${PNAME}_SOURCE )

        if( NOT EXISTS ${${PNAME}_SOURCE} OR NOT EXISTS ${${PNAME}_SOURCE}/CMakeLists.txt )
            message( FATAL_ERROR "User defined source directory '${${PNAME}_SOURCE}' for project '${PROJ_NAME}' does not exist or does not contain a CMakeLists.txt file." )
        endif()

        set( ${PNAME}_SOURCE_DIR "${${PNAME}_SOURCE}" )

    else() # default is 'dropped in' subdirectory named as project

        if( EXISTS ${CMAKE_CURRENT_SOURCE_DIR}/${PROJ_NAME} AND EXISTS ${CMAKE_CURRENT_SOURCE_DIR}/${PROJ_NAME}/CMakeLists.txt )
            set( ${PNAME}_SOURCE_DIR "${CMAKE_CURRENT_SOURCE_DIR}/${PROJ_NAME}" )
        endif()

    endif()

    # found the subproject source so add it

    if( DEFINED ${PNAME}_SOURCE_DIR )

        set( ${PNAME}_SOURCE_DIR ${${PNAME}_SOURCE_DIR} CACHE PATH "Path to ${PROJ_NAME} source directory" )

        option( BUILD_${PNAME}  "whether to build ${PROJ_NAME}" ON )

        if( BUILD_${PNAME} )
            add_subdirectory( ${${PNAME}_SOURCE_DIR} ${PROJ_NAME} )
        endif()

    endif()

endmacro()
