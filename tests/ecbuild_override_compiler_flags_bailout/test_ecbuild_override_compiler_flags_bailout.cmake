cmake_minimum_required( VERSION 3.18 FATAL_ERROR )

find_package( ecbuild 3.6 REQUIRED )

project(OverrideCompilerFlagsBailout VERSION 1.0 LANGUAGES Fortran)

set( OVERRIDECOMPILERFLAGSBAILOUT_Fortran_FLAGS "-developer_owned" )
set( ECBUILD_Fortran_FLAGS "-ecbuild_owned" )
set( ECBUILD_Fortran_FLAGS_BIT "-ecbuild_bit" )

ecbuild_override_compiler_flags(
  COMPILE_FLAGS ${CMAKE_CURRENT_SOURCE_DIR}/compiler_flags.cmake
  INHERIT_ECBUILD_FLAGS
)

if( NOT OVERRIDECOMPILERFLAGSBAILOUT_Fortran_FLAGS STREQUAL "-developer_owned" )
  message(FATAL_ERROR "Project Fortran flags should not be overwritten when bailout is triggered")
endif()

if( DEFINED OVERRIDECOMPILERFLAGSBAILOUT_Fortran_FLAGS_BIT )
  message(FATAL_ERROR "Build-type project Fortran flags should not be inherited when bailout is triggered")
endif()

ecbuild_add_library(
  TARGET  bailoutflags
  SOURCES emptyfile.F90
)

get_property( _flags SOURCE emptyfile.F90 PROPERTY COMPILE_FLAGS )
if( NOT _flags MATCHES "-developer_owned" )
  message(${_flags})
  message(FATAL_ERROR "Missing developer-owned Fortran flags for emptyfile.F90")
endif()
if( _flags MATCHES "-ecbuild_owned" )
  message(${_flags})
  message(FATAL_ERROR "ECBUILD common Fortran flags should not be inherited when bailout is triggered")
endif()
if( _flags MATCHES "-ecbuild_bit" )
  message(${_flags})
  message(FATAL_ERROR "ECBUILD build-type Fortran flags should not be inherited when bailout is triggered")
endif()
if( _flags MATCHES "-included_flag" )
  message(${_flags})
  message(FATAL_ERROR "Compile flags include should be skipped when bailout is triggered")
endif()
