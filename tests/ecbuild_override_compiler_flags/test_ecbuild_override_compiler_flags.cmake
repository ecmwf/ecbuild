cmake_minimum_required( VERSION 3.18 FATAL_ERROR )

find_package( ecbuild 3.6 REQUIRED )

project(OverrideCompilerFlags VERSION 1.0 LANGUAGES C CXX Fortran)

set( ECBUILD_C_FLAGS "-user_common_c" )
set( ECBUILD_C_FLAGS_DEBUG "-user_debug_c" )
set( ECBUILD_C_FLAGS_BIT "-user_bit_c" )
set( ECBUILD_Fortran_FLAGS "-user_common_fortran" )

ecbuild_override_compiler_flags(
  COMPILE_FLAGS ${CMAKE_CURRENT_SOURCE_DIR}/compiler_flags.cmake
  CACHE_ECBUILD_FLAGS
)

ecbuild_add_library(
   TARGET    overrideflags
   SOURCES   emptyfile.c emptyfile.cxx emptyfile.F90
)

get_property( _flags SOURCE emptyfile.c PROPERTY COMPILE_FLAGS )
if( NOT _flags MATCHES "-user_common_c" )
   message(${_flags})
   message(FATAL_ERROR "Missing cached common C flags for emptyfile.c")
endif()
if( NOT _flags MATCHES "-g -fPIC" )
   message(${_flags})
   message(FATAL_ERROR "Missing compile-flags file common C flags for emptyfile.c")
endif()
if( CMAKE_BUILD_TYPE MATCHES BIT )
   if( NOT _flags MATCHES "-user_bit_c" )
      message(${_flags})
      message(FATAL_ERROR "Missing cached BIT C flags for emptyfile.c")
   endif()
   if( NOT _flags MATCHES "-O2" )
      message(${_flags})
      message(FATAL_ERROR "Missing compile-flags file BIT C flags for emptyfile.c")
   endif()
elseif( CMAKE_BUILD_TYPE MATCHES DEBUG )
   if( NOT _flags MATCHES "-user_debug_c" )
      message(${_flags})
      message(FATAL_ERROR "Missing cached DEBUG C flags for emptyfile.c")
   endif()
   if( NOT _flags MATCHES "-O0" )
      message(${_flags})
      message(FATAL_ERROR "Missing compile-flags file DEBUG C flags for emptyfile.c")
   endif()
endif()

get_property( _flags SOURCE emptyfile.cxx PROPERTY COMPILE_FLAGS )
if( CMAKE_BUILD_TYPE MATCHES BIT )
   if( NOT _flags MATCHES "-g -fPIC -O2" )
      message(${_flags})
      message(FATAL_ERROR "Incorrect BIT flags for emptyfile.cxx")
   endif()
elseif( CMAKE_BUILD_TYPE MATCHES DEBUG )
   if( NOT _flags MATCHES "-g -fPIC -O0" )
      message(${_flags})
      message(FATAL_ERROR "Incorrect DEBUG flags for emptyfile.cxx")
   endif()
endif()

get_property( _flags SOURCE emptyfile.F90 PROPERTY COMPILE_FLAGS )
if( NOT _flags MATCHES "-user_common_fortran" )
   message(${_flags})
   message(FATAL_ERROR "Missing cached common Fortran flags for emptyfile.F90")
endif()
if( NOT _flags MATCHES "-g -fortran_only_flag" )
   message(${_flags})
   message(FATAL_ERROR "Missing compile-flags file Fortran flags for emptyfile.F90")
endif()
