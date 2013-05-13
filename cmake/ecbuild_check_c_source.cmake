# (C) Copyright 1996-2012 ECMWF.
# 
# This software is licensed under the terms of the Apache Licence Version 2.0
# which can be obtained at http://www.apache.org/licenses/LICENSE-2.0. 
# In applying this licence, ECMWF does not waive the privileges and immunities 
# granted to it by virtue of its status as an intergovernmental organisation nor
# does it submit to any jurisdiction.

##############################################################################
# macro that runs the given C code and returns its output

macro( ecbuild_check_c_source_return SOURCE VAR VAR_OUTPUT )

    if( NOT DEFINED ${VAR} )

        set(MACRO_CHECK_FUNCTION_DEFINITIONS "-D${VAR} ${CMAKE_REQUIRED_FLAGS}")
        if(CMAKE_REQUIRED_LIBRARIES)
          set(CHECK_C_SOURCE_COMPILES_ADD_LIBRARIES "-DLINK_LIBRARIES:STRING=${CMAKE_REQUIRED_LIBRARIES}")
        else()
          set(CHECK_C_SOURCE_COMPILES_ADD_LIBRARIES)
        endif()
        if(CMAKE_REQUIRED_INCLUDES)
          set(CHECK_C_SOURCE_COMPILES_ADD_INCLUDES "-DINCLUDE_DIRECTORIES:STRING=${CMAKE_REQUIRED_INCLUDES}")
        else()
          set(CHECK_C_SOURCE_COMPILES_ADD_INCLUDES)
        endif()
    
        # write the source file
    
        file( WRITE "${CMAKE_BINARY_DIR}${CMAKE_FILES_DIRECTORY}/CMakeTmp/test_${VAR}.c" "${SOURCE}\n" )
        file( WRITE "${CMAKE_BINARY_DIR}${CMAKE_FILES_DIRECTORY}/TestSrcs/${VAR}.c" "${SOURCE}\n" )

        message( STATUS "Performing Test ${VAR}" )
        try_run( ${VAR}_EXITCODE ${VAR}_COMPILED
          ${CMAKE_BINARY_DIR}
          ${CMAKE_BINARY_DIR}${CMAKE_FILES_DIRECTORY}/CMakeTmp/test_${VAR}.c
          COMPILE_DEFINITIONS ${CMAKE_REQUIRED_DEFINITIONS}
          CMAKE_FLAGS -DCOMPILE_DEFINITIONS:STRING=${MACRO_CHECK_FUNCTION_DEFINITIONS}
          -DCMAKE_SKIP_RPATH:BOOL=${CMAKE_SKIP_RPATH}
          "${CHECK_C_SOURCE_COMPILES_ADD_LIBRARIES}"
          "${CHECK_C_SOURCE_COMPILES_ADD_INCLUDES}"
          COMPILE_OUTPUT_VARIABLE compile_OUTPUT 
          RUN_OUTPUT_VARIABLE     run_OUTPUT )
    
        # if it did not compile make the return value fail code of 1
        if( NOT ${VAR}_COMPILED )
          set( ${VAR}_EXITCODE 1 )
        endif()
    
        # if the return value was 0 then it worked
        if("${${VAR}_EXITCODE}" EQUAL 0)
    
          message(STATUS "Performing Test ${VAR} - Success")
          file(APPEND ${CMAKE_BINARY_DIR}${CMAKE_FILES_DIRECTORY}/CMakeOutput.log 
            "Performing C SOURCE FILE Test ${VAR} succeded with the following compile output:\n"
            "${compile_OUTPUT}\n" 
            "Performing C SOURCE FILE Run ${VAR} succeded with the following run output:\n"
            "${run_OUTPUT}\n" 
            "Return value: ${${VAR}}\n"
            "Source file was:\n${SOURCE}\n")

          set( ${VAR}     1              CACHE INTERNAL "Test ${VAR}")
          set( ${VAR_OUTPUT} "${run_OUTPUT}" CACHE INTERNAL "Test ${VAR} output")
    
        else()
    
          if(CMAKE_CROSSCOMPILING AND "${${VAR}_EXITCODE}" MATCHES  "FAILED_TO_RUN")
            set(${VAR} "${${VAR}_EXITCODE}")
            set(${OUTPUT} "")
          else()
            set(${VAR} "" CACHE INTERNAL "Test ${VAR}")
            set(${VAR_OUTPUT} "" CACHE INTERNAL "Test ${VAR} output")
          endif()
    
          message(STATUS "Performing Test ${VAR} - Failed")
          file(APPEND ${CMAKE_BINARY_DIR}${CMAKE_FILES_DIRECTORY}/CMakeError.log 
            "Performing C SOURCE FILE Test ${VAR} failed with the following compile output:\n"
            "${compile_OUTPUT}\n" 
            "Performing C SOURCE FILE Run ${VAR} failed with the following run output:\n"
            "${run_OUTPUT}\n" 
            "Return value: ${${VAR}_EXITCODE}\n"
            "Source file was:\n${SOURCE}\n")
        endif()
    
    endif()

endmacro()

##############################################################################
# macro that only adds a c flag if compiler supports it

macro( cmake_add_c_flags m_c_flags )

  if( NOT DEFINED N_CFLAG )
    set( N_CFLAG 0 )
  endif()

  math( EXPR N_CFLAG '${N_CFLAG}+1' )

  check_c_compiler_flag( ${m_c_flags} C_FLAG_TEST_${N_CFLAG} )

  if( C_FLAG_TEST_${N_CFLAG} )
    set( CMAKE_C_FLAGS "${CMAKE_C_FLAGS} ${m_c_flags}" )
    message( STATUS "C FLAG [${m_c_flags}] added" )
  else()
    message( STATUS "C FLAG [${m_c_flags}] skipped" )
  endif()

endmacro()

