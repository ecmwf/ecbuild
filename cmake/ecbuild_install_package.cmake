# (C) Copyright 1996-2012 ECMWF.
# 
# This software is licensed under the terms of the Apache Licence Version 2.0
# which can be obtained at http://www.apache.org/licenses/LICENSE-2.0. 
# In applying this licence, ECMWF does not waive the privileges and immunities 
# granted to it by virtue of its status as an intergovernmental organisation nor
# does it submit to any jurisdiction.

###############################################################################

function( __ecbuild_create_cpack_config filename )

  set(CPACK_OUTPUT_CONFIG_FILE "${filename}")
  include(CPack)

endfunction( __ecbuild_create_cpack_config )

###############################################################################

macro( ecbuild_install_project )


    set( options )
    set( single_value_args NAME FILENAME DESCRIPTION )
    set( multi_value_args  COMPONENTS )

    cmake_parse_arguments( _PAR "${options}" "${single_value_args}" "${multi_value_args}"  ${_FIRST_ARG} ${ARGN} )

    if(_PAR_UNPARSED_ARGUMENTS)
      message(FATAL_ERROR "Unknown keywords given to ecbuild_install_project(): \"${_PAR_UNPARSED_ARGUMENTS}\"")
    endif()

    if( NOT _PAR_NAME  )
      message(FATAL_ERROR "The call to ecbuild_install_project() doesn't specify the NAME.")
    endif()



    ### PACKAGING

    string( TOUPPER ${PROJECT_NAME} PNAME )
    string( TOLOWER ${PROJECT_NAME} LNAME )
    
    # components

    if( DEFINED _PAR_COMPONENTS )
        set(CPACK_COMPONENTS_ALL   "${_PAR_COMPONENTS}")
    else()
        set(CPACK_COMPONENTS_ALL   "${PROJECT_NAME}")
    endif()
    
    # filename MarsServer-...-tar.gz

    if( DEFINED _PAR_FILENAME )
        set(CPACK_PACKAGE_FILE_NAME   "${_PAR_FILENAME}")
    else()
        set(CPACK_PACKAGE_FILE_NAME   "${_PAR_NAME}")
    endif()

    # name version etc

    set(CPACK_PACKAGE_NAME      "${_PAR_NAME}")
    set(CPACK_PACKAGE_VERSION   "${${PNAME}_VERSION_STR}")

    set(CPACK_GENERATOR        "TGZ")
    set(CPACK_PACKAGE_VENDOR   "ECMWF")

    # short description

    if( DEFINED _PAR_DESCRIPTION )
        set(CPACK_PACKAGE_DESCRIPTION_SUMMARY "${_PAR_DESCRIPTION}" )
    else()
        set(CPACK_PACKAGE_DESCRIPTION_SUMMARY "")
    endif()

    # long description

    if( EXISTS ${PROJECT_SOURCE_DIR}/INSTALL )
        set(CPACK_PACKAGE_DESCRIPTION_FILE "${PROJECT_SOURCE_DIR}/INSTALL")
    endif()
    if( EXISTS ${PROJECT_SOURCE_DIR}/LICENSE )
        set(CPACK_RESOURCE_FILE_LICENSE    "${PROJECT_SOURCE_DIR}/LICENSE")
    endif()

    # set(CPACK_PACKAGE_EXECUTABLES ${ECBUILD_ALL_EXES})
    
    # what to pack and not

    set(CPACK_SOURCE_IGNORE_FILES
        /build/
        /\\\\.git/
        /\\\\.svn/
        CMakeLists.txt.user
        \\\\.swp$
        p4config
    )

    # skip the files that were declared as DONT_PACK

    list( APPEND CPACK_SOURCE_IGNORE_FILES ${ECBUILD_DONT_PACK_FILES} )

    # cpack config file

    set(CPACK_INSTALL_CMAKE_PROJECTS "${${PROJECT_NAME}_BINARY_DIR}" "${PROJECT_NAME}" "${CPACK_COMPONENTS_ALL}" "*" )

    __ecbuild_create_cpack_config( CPackConfig-${_PAR_NAME}.cmake )

   

    ### EXPORTS
 
    # TOP-LEVEL PROJECT EXPORT
    if( ${PROJECT_NAME} STREQUAL ${CMAKE_PROJECT_NAME} )

        # exports the package for use from the build-tree -- inserts <package> into the CMake user package registry
    
        export( PACKAGE ${PROJECT_NAME} )
         
        set( _template_config "${ECBUILD_MACROS_DIR}/project-config.cmake.in" )
        if( EXISTS ${LNAME}-config.cmake.in )
            set( _template_config "${LNAME}-config.cmake.in" )
        endif()
    
        set( _template_config_version "${ECBUILD_MACROS_DIR}/project-config-version.cmake.in" )
        if( EXISTS ${LNAME}-config-version.cmake.in )
            set( _template_config_version "${LNAME}-config-version.cmake.in" )
        endif()
    
        # project-config-version.cmake -- format ([0-9]+).([0-9]+).([0-9]+)
    
        set( PACKAGE_VERSION "${${PNAME}_VERSION}" ) 
        
        configure_file( "${_template_config_version}" "${PROJECT_BINARY_DIR}/${LNAME}-config-version.cmake" @ONLY )

        # prepare imutable variables (don't depend on install path)
                        
        set( CONF_LIBRARIES ${${PROJECT_NAME}_ALL_LIBS} )
        if( ${PNAME}_LIBRARIES )
            set( CONF_LIBRARIES ${${PNAME}_LIBRARIES} )
        endif()
                    
        set( CONF_DEFINITIONS "" )
        if( ${PNAME}_DEFINITIONS )
           set( CONF_DEFINITIONS ${${PNAME}_DEFINITIONS} )
        endif()

        set( CONF_TPL_LIBRARIES   "" )
        set( CONF_TPL_DEFINITIONS "" )
        foreach( _tpl ${${PNAME}_TPLS} )
            string( TOUPPER ${_tpl} TPL )
            if( ${TPL}_LIBRARIES )
                list( APPEND CONF_TPL_LIBRARIES   ${${TPL}_LIBRARIES} )
            endif()
            if( ${TPL}_DEFINITIONS )
                list( APPEND CONF_TPL_DEFINITIONS ${${TPL}_DEFINITIONS} )
            endif()
        endforeach()
   
        # project-config.cmake @ build tree

        set( CONF_TPLS ${${PNAME}_TPLS} )

        set( CONF_INCLUDE_DIRS "${PROJECT_SOURCE_DIR}" "${PROJECT_BINARY_DIR}" )
        if( ${PNAME}_INCLUDE_DIRS )
            set( CONF_INCLUDE_DIRS ${${PNAME}_INCLUDE_DIRS} )
        endif()

        set( CONF_TPL_INCLUDE_DIRS "" )
        foreach( _tpl ${${PNAME}_TPLS} )
            string( TOUPPER ${_tpl} TPL )
            if( ${TPL}_INCLUDE_DIRS )
                list( APPEND CONF_TPL_INCLUDE_DIRS ${${TPL}_INCLUDE_DIRS} )
            endif()
        endforeach()

        configure_file( "${_template_config}" "${PROJECT_BINARY_DIR}/${LNAME}-config.cmake" @ONLY )
    
        # project-config.cmake @ install tree
        
        file( RELATIVE_PATH REL_INCLUDE_DIR "${INSTALL_CMAKE_DIR}" "${INSTALL_INCLUDE_DIR}" )
        set( CONF_INCLUDE_DIRS "\${${PNAME}_CMAKE_DIR}/${REL_INCLUDE_DIR}" )

        set( CONF_TPL_INCLUDE_DIRS "" )
        foreach( _tpl ${${PNAME}_TPLS} )
            string( TOUPPER ${_tpl} TPL )
            if( ${TPL}_FULL_INSTALL_INCLUDE_DIR )
                file( RELATIVE_PATH REL_INCLUDE_DIR "${INSTALL_CMAKE_DIR}" "${${TPL}_FULL_INSTALL_INCLUDE_DIR}" )
                list( APPEND CONF_TPL_INCLUDE_DIRS "\${${PNAME}_CMAKE_DIR}/${REL_INCLUDE_DIR}" )
            endif()
        endforeach()
        
        configure_file( "${_template_config}" "${PROJECT_BINARY_DIR}${CMAKE_FILES_DIRECTORY}/${LNAME}-config.cmake" @ONLY )
     
        # install the ${LNAME}-config.cmake and ${LNAME}-config-version.cmake
    
        install( FILES
            "${PROJECT_BINARY_DIR}${CMAKE_FILES_DIRECTORY}/${LNAME}-config.cmake"
            "${PROJECT_BINARY_DIR}/${LNAME}-config-version.cmake"
            DESTINATION "${INSTALL_CMAKE_DIR}" )
     
        # install the export
    
        if( ${PROJECT_NAME}_ALL_EXES OR ${PROJECT_NAME}_ALL_LIBS )
            install( EXPORT ${PROJECT_NAME}-targets DESTINATION "${INSTALL_CMAKE_DIR}" )
        endif()
    
    else() ### SUB-PROJECT EXPORT

        set( ${PNAME}_FOUND  TRUE  PARENT_SCOPE )
        set( ${PNAME}_VERSION ${${PNAME}_VERSION} PARENT_SCOPE )

        if( ${PNAME}_INCLUDE_DIRS )
            set( ${PNAME}_INCLUDE_DIRS ${${PNAME}_INCLUDE_DIRS} PARENT_SCOPE )
        endif()
        
        if( ${PNAME}_LIBRARIES )
            set( ${PNAME}_LIBRARIES ${${PNAME}_LIBRARIES} PARENT_SCOPE )
        endif()
                
        if( ${PNAME}_DEFINITIONS )
            set( ${PNAME}_DEFINITIONS ${${PNAME}_DEFINITIONS} PARENT_SCOPE )
        endif()

    endif()

endmacro( ecbuild_install_project )
