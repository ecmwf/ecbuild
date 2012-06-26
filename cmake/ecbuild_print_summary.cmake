# (C) Copyright 1996-2012 ECMWF.
# 
# This software is licensed under the terms of the Apache Licence Version 2.0
# which can be obtained at http://www.apache.org/licenses/LICENSE-2.0. 
# In applying this licence, ECMWF does not waive the privileges and immunities 
# granted to it by virtue of its status as an intergovernmental organisation nor
# does it submit to any jurisdiction.

macro( ecbuild_print_summary )

    if( EXISTS ${PROJECT_SOURCE_DIR}/project_summary.cmake )
        include( ${PROJECT_SOURCE_DIR}/project_summary.cmake )
    endif()
    
    if( ${PROJECT_NAME} STREQUAL ${CMAKE_PROJECT_NAME} )
    
        ecbuild_define_links_target()
    
        get_property( langs GLOBAL PROPERTY ENABLED_LANGUAGES )
    
        message( STATUS "---------------------------------------------------------" )
        message( STATUS " Build summary" )
        message( STATUS "---------------------------------------------------------" )
    
        message( STATUS " operating system : [${CMAKE_SYSTEM}] [${EC_OS_NAME}.${EC_OS_BITS}]" )
        message( STATUS " cmake            : [${CMAKE_COMMAND}] (${CMAKE_MAJOR_VERSION}.${CMAKE_MINOR_VERSION}.${CMAKE_PATCH_VERSION})" )
        message( STATUS " build type       : [${CMAKE_BUILD_TYPE}]" )
        message( STATUS " timestamp        : [${EC_BUILD_TIMESTAMP}]" )
        message( STATUS " install prefix   : [${CMAKE_INSTALL_PREFIX}]" )
    if( EC_LINK_DIR )
        message( STATUS " links prefix     : [${EC_LINK_DIR}]" )
    #    debug_var( EC_ALL_EXES )
    #    debug_var( EC_ALL_LIBS )
    endif()
        message( STATUS "---------------------------------------------------------" )
    
        message( STATUS " Compiler info    : [${CMAKE_CXX_COMPILER_ID} ${EC_COMPILER_VERSION}]" )
    
        foreach( lang ${langs} )
          message( STATUS " > ${lang} [${CMAKE_${lang}_COMPILER} ${EC_${lang}_FLAGS_ALL}]" )
        endforeach()
    
        if( ( NOT "${CMAKE_EXEC_LINKER_FLAGS}" MATCHES "^[ ]*$" ) OR ( NOT "${CMAKE_EXEC_LINKER_FLAGS_${EC_BUILD_TYPE}}" MATCHES "^[ ]*$" ) )
            message( STATUS " shared exe flags : [${CMAKE_EXE_LINKER_FLAGS} ${CMAKE_EXEC_LINKER_FLAGS_${EC_BUILD_TYPE}}]" )
        endif()
        if( ( NOT "${CMAKE_SHARED_LINKER_FLAGS}" MATCHES "^[ ]*$" ) OR ( NOT "${CMAKE_SHARED_LINKER_FLAGS_${EC_BUILD_TYPE}}" MATCHES "^[ ]*$" ) )
            message( STATUS " shared link flags: [${CMAKE_SHARED_LINKER_FLAGS} ${CMAKE_SHARED_LINKER_FLAGS_${EC_BUILD_TYPE}}]" )
        endif()

        message( STATUS "---------------------------------------------------------" )
    
    if( EC_BIG_ENDIAN )
        message( STATUS " Big endian [${EC_BIG_ENDIAN}] IEEE BE [${IEEE_BE}]" )
    endif()
    if( EC_LITTLE_ENDIAN )
        message( STATUS " Little endian [${EC_LITTLE_ENDIAN}] IEEE LE [${IEEE_LE}]" )
    endif()
    
        message( STATUS " sizeof - void*  [${EC_SIZEOF_PTR}] - int    [${EC_SIZEOF_INT}]" )
        message( STATUS "        - short  [${EC_SIZEOF_SHORT}] - long   [${EC_SIZEOF_LONG}] - long long [${EC_SIZEOF_LONG_LONG}]" )
        message( STATUS "        - float  [${EC_SIZEOF_FLOAT}] - double [${EC_SIZEOF_DOUBLE}]" )
        message( STATUS "        - size_t [${EC_SIZEOF_SIZE_T}] - off_t  [${EC_SIZEOF_OFF_T}]" )
    
        message( STATUS "---------------------------------------------------------" )
    
    endif()
    
    # issue warnings / errors in case ther are unused project files
    ecbuild_warn_unused_files()

endmacro( ecbuild_print_summary )
