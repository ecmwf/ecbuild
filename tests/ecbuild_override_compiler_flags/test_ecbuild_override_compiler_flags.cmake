cmake_minimum_required( VERSION 3.18 FATAL_ERROR )

find_package( ecbuild 3.6 REQUIRED )

project(OverrideCompilerFlags VERSION 1.0 LANGUAGES C CXX Fortran)

ecbuild_override_compiler_flags( COMPILE_FLAGS compiler_flags.cmake )

ecbuild_add_library(
   TARGET    overrideflags
   SOURCES   emptyfile.c emptyfile.cxx emptyfile.F90
)

get_property( _flags SOURCE emptyfile.c PROPERTY COMPILE_FLAGS )
if( CMAKE_BUILD_TYPE MATCHES BIT )
   if( NOT ${_flags} MATCHES "-g -fPIC -O2" )
      message(${_flags})
      message(FATAL_ERROR "Incorrect BIT flags for emptyfile.c")
   endif()
elseif( CMAKE_BUILD_TYPE MATCHES DEBUG )
   if( NOT ${_flags} MATCHES "-g -fPIC -O0" )
      message(${_flags})
      message(FATAL_ERROR "Incorrect DEBUG flags for emptyfile.c")
   endif()
endif()

get_property( _flags SOURCE emptyfile.cxx PROPERTY COMPILE_FLAGS )
if( CMAKE_BUILD_TYPE MATCHES BIT )
   if( NOT ${_flags} MATCHES "-g -fPIC -O2" )
      message(${_flags})
      message(FATAL_ERROR "Incorrect BIT flags for emptyfile.cxx")
   endif()
elseif( CMAKE_BUILD_TYPE MATCHES DEBUG )
   if( NOT ${_flags} MATCHES "-g -fPIC -O0" )
      message(${_flags})
      message(FATAL_ERROR "Incorrect DEBUG flags for emptyfile.cxx")
   endif()
endif()

get_property( _flags SOURCE emptyfile.F90 PROPERTY COMPILE_FLAGS )
if( NOT ${_flags} MATCHES "-g -fortran_only_flag" )
   message(${_flags})
   message(FATAL_ERROR "Incorrect flags for emptyfile.F90")
endif()

