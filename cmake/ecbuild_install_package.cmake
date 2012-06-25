# (C) Copyright 1996-2012 ECMWF.
# 
# This software is licensed under the terms of the Apache Licence Version 2.0
# which can be obtained at http://www.apache.org/licenses/LICENSE-2.0. 
# In applying this licence, ECMWF does not waive the privileges and immunities 
# granted to it by virtue of its status as an intergovernmental organisation nor
# does it submit to any jurisdiction.

function(create_cpack_config filename)
  set(CPACK_OUTPUT_CONFIG_FILE "${filename}")
  include(CPack)
endfunction(create_cpack_config)

macro( ecbuild_install_project )

    set( options )
    set( single_value_args NAME FILENAME DESCRIPTION )
    set( multi_value_args  COMPONENTS )

    cmake_parse_arguments( _PAR "${options}" "${single_value_args}" "${multi_value_args}"  ${_FIRST_ARG} ${ARGN} )

    if(_PAR_UNPARSED_ARGUMENTS)
      message(FATAL_ERROR "Unknown keywords given to ecbuild_add_library(): \"${_PAR_UNPARSED_ARGUMENTS}\"")
    endif()

    if( NOT _PAR_NAME  )
      message(FATAL_ERROR "The call to ecbuild_install_project() doesn't specify the NAME.")
    endif()

    string( TOUPPER ${PROJECT_NAME} PNAME )
    
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
    set(CPACK_PACKAGE_VERSION   "${${PNAME}_VERSION}")

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

    create_cpack_config( CPackConfig-${_PAR_NAME}.cmake )

endmacro( ecbuild_install_project )
