# (C) Copyright 1996-2012 ECMWF.
# 
# This software is licensed under the terms of the Apache Licence Version 2.0
# which can be obtained at http://www.apache.org/licenses/LICENSE-2.0. 
# In applying this licence, ECMWF does not waive the privileges and immunities 
# granted to it by virtue of its status as an intergovernmental organisation nor
# does it submit to any jurisdiction.

##############################################################################
# macro for adding a test
##############################################################################

macro( ecbuild_add_test )

    set( options ) # no options
    set( single_value_args TARGET ENABLED )
    set( multi_value_args  SOURCES LIBS INCLUDES DEPENDS ARGS PERSISTENT DEFINITIONS RESOURCES CFLAGS CXXFLAGS FFLAGS )

    cmake_parse_arguments( _PAR "${options}" "${single_value_args}" "${multi_value_args}"  ${_FIRST_ARG} ${ARGN} )

    if(_PAR_UNPARSED_ARGUMENTS)
      message(FATAL_ERROR "Unknown keywords given to ecbuild_add_test(): \"${_PAR_UNPARSED_ARGUMENTS}\"")
    endif()

    if( NOT _PAR_TARGET  )
      message(FATAL_ERROR "The call to ecbuild_add_test() doesn't specify the TARGET.")
    endif()

    if( NOT _PAR_SOURCES )
      message(FATAL_ERROR "The call to ecbuild_add_test() doesn't specify the SOURCES.")
    endif()

    # add include dirs if defined
    if( DEFINED _PAR_INCLUDES )
      foreach( path ${_PAR_INCLUDES} ) # skip NOTFOUND
        if( path )
          include_directories( ${path} )
#        else()
#          message( WARNING "Path ${path} was skipped" )
        endif()
      endforeach()
    endif()

    # add persistent layer files
    if( DEFINED _PAR_PERSISTENT )
        ecbuild_add_persistent( SRC_LIST _PAR_SOURCES FILES  ${_PAR_PERSISTENT} )
    endif()

    # add the test target
    add_executable( ${_PAR_TARGET} ${_PAR_SOURCES} )

    # add extra dependencies
    if( DEFINED _PAR_DEPENDS)
      add_dependencies( ${_PAR_TARGET} ${_PAR_DEPENDS} )
    endif()

    # add resources
        if( DEFINED _PAR_RESOURCES)
                foreach( rfile ${_PAR_RESOURCES} )
                    add_custom_command( TARGET ${_PAR_TARGET} POST_BUILD
                        COMMAND ${CMAKE_COMMAND} -E copy_if_different ${CMAKE_CURRENT_SOURCE_DIR}/${rfile} ${CMAKE_CURRENT_BINARY_DIR} )
                endforeach()
    endif()

    # add the link libraries
    if( DEFINED _PAR_LIBS )
	target_link_libraries( ${_PAR_TARGET} ${_PAR_LIBS} )
#      foreach( lib ${_PAR_LIBS} ) # skip NOTFOUND
#        if( lib )
#          target_link_libraries( ${_PAR_TARGET} ${lib} )
#        else()
#          message( WARNING "Lib ${lib} was skipped" )
#        endif()
#      endforeach()
    endif()

    # add local flags
    if( DEFINED _PAR_CFLAGS )
        set_source_files_properties( ${${_PAR_TARGET}_c_srcs}   PROPERTIES COMPILE_FLAGS "${_PAR_CFLAGS}" )
    endif()
    if( DEFINED _PAR_CXXFLAGS )
        set_source_files_properties( ${${_PAR_TARGET}_cxx_srcs} PROPERTIES COMPILE_FLAGS "${_PAR_CXXFLAGS}" )
    endif()
    if( DEFINED _PAR_FFLAGS )
        set_source_files_properties( ${${_PAR_TARGET}_f_srcs}   PROPERTIES COMPILE_FLAGS "${_PAR_FFLAGS}" )
    endif()

    # add definitions to compilation
    if( DEFINED _PAR_DEFINITIONS )
        get_property( _target_defs TARGET ${_PAR_TARGET} PROPERTY COMPILE_DEFINITIONS )
        list( APPEND _target_defs ${_PAR_DEFINITIONS} )
        set_property( TARGET ${_PAR_TARGET} PROPERTY COMPILE_DEFINITIONS ${_target_defs} )
    endif()

    # set build location to local build dir
    # not the project base as defined for libs and execs
    set_property( TARGET ${_PAR_TARGET} PROPERTY RUNTIME_OUTPUT_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR} )

    # make sure target is removed before - some problems with AIX
    get_target_property(EXE_FILENAME ${_PAR_TARGET} OUTPUT_NAME)
    add_custom_command(
          TARGET ${_PAR_TARGET}
          PRE_BUILD
          COMMAND ${CMAKE_COMMAND} -E remove ${EXE_FILENAME}
    )

    # define the arguments
    set( TEST_ARGS "" )
    if( DEFINED _PAR_ARGS  )
      list ( APPEND TEST_ARGS ${_PAR_ARGS} )
    endif()

    # mark project files
    ecbuild_declare_project_files( ${_PAR_SOURCES} )

    # define the test]
    if( NOT DEFINED _PAR_ENABLED )
        set( _PAR_ENABLED 1 )
    endif()
    if( _PAR_ENABLED )
        add_test( ${_PAR_TARGET} ${_PAR_TARGET} ${TEST_ARGS} )
    endif()

    # add to the overall list of tests
    list( APPEND ECMWF_ALL_TESTS ${_PAR_TARGET} )
    set( ECMWF_ALL_TESTS ${ECMWF_ALL_TESTS} CACHE INTERNAL "" )

endmacro( ecbuild_add_test )
