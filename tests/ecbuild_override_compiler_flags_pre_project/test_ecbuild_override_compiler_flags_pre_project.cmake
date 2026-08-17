cmake_minimum_required( VERSION 3.18 FATAL_ERROR )

find_package( ecbuild 3.6 REQUIRED )

set( ECBUILD_COMPILE_FLAGS ${CMAKE_CURRENT_SOURCE_DIR}/compiler_flags.cmake )
set( ECBUILD_C_FLAGS "-ecbuild_owned" )

project(OverrideCompilerFlagsPreProject VERSION 1.0 LANGUAGES C)

if( DEFINED _C_FLAGS )
  message(${_C_FLAGS})
  message(FATAL_ERROR "ECBUILD C flags should not be inherited when ECBUILD_COMPILE_FLAGS is set before project()")
endif()

ecbuild_add_library(
  TARGET  preprojectflags
  SOURCES emptyfile.c
)

get_property( _flags SOURCE emptyfile.c PROPERTY COMPILE_FLAGS )
if( NOT _flags MATCHES "-included_flag" )
  message(${_flags})
  message(FATAL_ERROR "Missing compile-flags file flag for emptyfile.c")
endif()
if( _flags MATCHES "-ecbuild_owned" )
  message(${_flags})
  message(FATAL_ERROR "ECBUILD C flags should not be set for emptyfile.c")
endif()
