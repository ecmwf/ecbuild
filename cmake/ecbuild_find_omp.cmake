# (C) Copyright 1996-2014 ECMWF.
#
# This software is licensed under the terms of the Apache Licence Version 2.0
# which can be obtained at http://www.apache.org/licenses/LICENSE-2.0.
# In applying this licence, ECMWF does not waive the privileges and immunities
# granted to it by virtue of its status as an intergovernmental organisation nor
# does it submit to any jurisdiction.

##############################################################################
# macro for adding a test
##############################################################################

macro( ecbuild_find_omp )

  set(_OMP_FLAG_GNU "-fopenmp")
  set(_NO_OMP_FLAG_GNU "-fno-openmp")

  set(_OMP_FLAG_Cray "-homp")
  set(_NO_OMP_FLAG_Cray "-hnoomp")

  set(_OMP_FLAG_XL "-qsmp=omp")
  set(_NO_OMP_FLAG_XL "-qsmp=noomp")

  set(_OMP_FLAG_Intel "-openmp")
  set(_NO_OMP_FLAG_Intel "-openmp-stubs")


  set( options )
  set( single_value_args ENABLE )
  set( multi_value_args  )

  cmake_parse_arguments( _PAR "${options}" "${single_value_args}" "${multi_value_args}"  ${_FIRST_ARG} ${ARGN} )

  set( _ENABLE TRUE )
  if( DEFINED _PAR_ENABLE )
    set( _ENABLE ${_PAR_ENABLE} )
  endif()


  if( NOT ${_ENABLE} )
    set(_prefix "_NO")
  endif()

  if( DEFINED _OMP_FLAG_${CMAKE_Fortran_COMPILER_ID} )
    set( _OMP_Fortran_FLAG "${_OMP_FLAG_${CMAKE_Fortran_COMPILER_ID}}" )
    set( _NO_OMP_Fortran_FLAG "${_NO_OMP_FLAG_${CMAKE_Fortran_COMPILER_ID}}" )
  endif()

  if( DEFINED _OMP_FLAG_${CMAKE_C_COMPILER_ID} )
    set( _OMP_C_FLAG "${_OMP_FLAG_${CMAKE_C_COMPILER_ID}}" )
    set( _NO_OMP_C_FLAG "${_NO_OMP_FLAG_${CMAKE_C_COMPILER_ID}}" )
  endif()

  if( DEFINED _OMP_FLAG_${CMAKE_CXX_COMPILER_ID} )
    set( _OMP_CXX_FLAG "${_OMP_FLAG_${CMAKE_CXX_COMPILER_ID}}" )
    set( _NO_OMP_C_FLAG "${_NO_OMP_FLAG_${CMAKE_CXX_COMPILER_ID}}" )
  endif()


  # sample openmp source code to test
  set(OMP_C_TEST_SOURCE
  "
  #include <omp.h>
  int main() {
  #ifdef _OPENMP
    return 0;
  #else
    breaks_on_purpose
  #endif
  }
  ")

  # sample openmp source code to test
  set(OMPSTUBS_C_TEST_SOURCE
  "
  #include <omp.h>
  int main() {
  #ifdef _OPENMP
    breaks_on_purpose
  #else
    return 0;
  #endif
  }
  ")

  # sample openmp source code to test
  set(OMP_Fortran_TEST_SOURCE
  "
  program main
    use omp_lib
  end program
  ")

  if( CMAKE_C_COMPILER_LOADED AND _OMP_C_FLAG )
    set(SAVE_CMAKE_REQUIRED_FLAGS "${CMAKE_REQUIRED_FLAGS}")
    set(CMAKE_REQUIRED_FLAGS "${_OMP_C_FLAG}")
    #unset(C_COMPILER_SUPPORTS_OMP CACHE)
    #message(STATUS "Try OMP C flag = [${_OMP_C_FLAG}]")
    check_c_source_compiles("${OMP_C_TEST_SOURCE}" C_COMPILER_SUPPORTS_OMP )
    set(CMAKE_REQUIRED_FLAGS "${SAVE_CMAKE_REQUIRED_FLAGS}")
    if( C_COMPILER_SUPPORTS_OMP )
      set(SAVE_CMAKE_REQUIRED_FLAGS "${CMAKE_REQUIRED_FLAGS}")
      set(CMAKE_REQUIRED_FLAGS "${_NO_OMP_C_FLAG}")
      #unset(C_COMPILER_SUPPORTS_OMPSTUBS CACHE)
      #message(STATUS "Try OMP C flag = [${_NO_OMP_C_FLAG}]")
      check_c_source_compiles("${OMPSTUBS_C_TEST_SOURCE}" C_COMPILER_SUPPORTS_OMPSTUBS )
      set(CMAKE_REQUIRED_FLAGS "${SAVE_CMAKE_REQUIRED_FLAGS}")
    endif()
  endif()
  if( CMAKE_CXX_COMPILER_LOADED AND _OMP_CXX_FLAG )
    set(SAVE_CMAKE_REQUIRED_FLAGS "${CMAKE_REQUIRED_FLAGS}")
    set(CMAKE_REQUIRED_FLAGS "${_OMP_CXX_FLAG}")
    #unset(CXX_COMPILER_SUPPORTS_OMP CACHE)
    #message(STATUS "Try OMP C++ flag = [${_OMP_CXX_FLAG}]")
    check_cxx_source_compiles("${OMP_C_TEST_SOURCE}" CXX_COMPILER_SUPPORTS_OMP )
    set(CMAKE_REQUIRED_FLAGS "${SAVE_CMAKE_REQUIRED_FLAGS}")
    if( CXX_COMPILER_SUPPORTS_OMP )
      set(SAVE_CMAKE_REQUIRED_FLAGS "${CMAKE_REQUIRED_FLAGS}")
      set(CMAKE_REQUIRED_FLAGS "${_NO_OMP_CXX_FLAG}")
      #unset(CXX_COMPILER_SUPPORTS_OMPSTUBS CACHE)
      #message(STATUS "Try OMP C++ flag = [${_NO_OMP_CXX_FLAG}]")
      check_c_source_compiles("${OMPSTUBS_C_TEST_SOURCE}" CXX_COMPILER_SUPPORTS_OMPSTUBS )
      set(CMAKE_REQUIRED_FLAGS "${SAVE_CMAKE_REQUIRED_FLAGS}")
    endif()
  endif()
  if( CMAKE_Fortran_COMPILER_LOADED AND _OMP_Fortran_FLAG )
    set(SAVE_CMAKE_REQUIRED_FLAGS "${CMAKE_REQUIRED_FLAGS}")
    set(CMAKE_REQUIRED_FLAGS "${_OMP_Fortran_FLAG}")
    #unset(Fortran_COMPILER_SUPPORTS_OMP CACHE)
    #message(STATUS "Try OMP Fortran flag = [${_OMP_Fortran_FLAG}]")
    check_fortran_source_compiles("${OMP_Fortran_TEST_SOURCE}" Fortran_COMPILER_SUPPORTS_OMP )
    set(CMAKE_REQUIRED_FLAGS "${SAVE_CMAKE_REQUIRED_FLAGS}")
    if( Fortran_COMPILER_SUPPORTS_OMP )
      set(SAVE_CMAKE_REQUIRED_FLAGS "${CMAKE_REQUIRED_FLAGS}")
      set(CMAKE_REQUIRED_FLAGS "${_NO_OMP_Fortran_FLAG}")
      #unset(Fortran_COMPILER_SUPPORTS_OMPSTUBS CACHE)
      #message(STATUS "Try OMP Fortran flag = [${_NO_OMP_Fortran_FLAG}]")
      check_fortran_source_compiles("${OMP_Fortran_TEST_SOURCE}" Fortran_COMPILER_SUPPORTS_OMPSTUBS )
      set(CMAKE_REQUIRED_FLAGS "${SAVE_CMAKE_REQUIRED_FLAGS}")
    endif()
  endif()

  if( C_COMPILER_SUPPORTS_OMP )
    set( OMP_C_FLAGS ${_OMP_C_FLAG} CACHE INTERNAL "OMP C flag" )
  endif()

  if( CXX_COMPILER_SUPPORTS_OMP )
    set( OMP_CXX_FLAGS ${_OMP_CXX_FLAG} CACHE INTERNAL "OMP C++ flag" )
  endif()

  if( Fortran_COMPILER_SUPPORTS_OMP )
    set( OMP_Fortran_FLAGS ${_OMP_Fortran_FLAG} CACHE INTERNAL "OMP Fortran flag" )
  endif()


  if( C_COMPILER_SUPPORTS_OMPSTUBS )
    set( OMPSTUBS_C_FLAGS ${_NO_OMP_C_FLAG} CACHE INTERNAL "OMP stubs C flag" )
  endif()

  if( CXX_COMPILER_SUPPORTS_OMPSTUBS )
    set( OMPSTUBS_CXX_FLAGS ${_NO_OMP_CXX_FLAG} CACHE INTERNAL "OMP stubs C++ flag" )
  endif()

  if( Fortran_COMPILER_SUPPORTS_OMPSTUBS )
    set( OMPSTUBS_Fortran_FLAGS ${_NO_OMP_Fortran_FLAG} CACHE INTERNAL "OMP stubs Fortran flag" )
  endif()


  include(FindPackageHandleStandardArgs)

  set( OMP_C_FIND_QUIETLY TRUE )
  set( OMP_CXX_FIND_QUIETLY TRUE )
  set( OMP_Fortran_FIND_QUIETLY TRUE )
  find_package_handle_standard_args( OMP_C       REQUIRED_VARS C_COMPILER_SUPPORTS_OMP  )
  find_package_handle_standard_args( OMP_CXX     REQUIRED_VARS CXX_COMPILER_SUPPORTS_OMP )
  find_package_handle_standard_args( OMP_Fortran REQUIRED_VARS Fortran_COMPILER_SUPPORTS_OMP )
  set( OMP_Fortran_FOUND ${OMP_FORTRAN_FOUND} CACHE INTERNAL "")

  set( OMPSTUBS_C_FIND_QUIETLY TRUE )
  set( OMPSTUBS_CXX_FIND_QUIETLY TRUE )
  set( OMPSTUBS_Fortran_FIND_QUIETLY TRUE )
  find_package_handle_standard_args( OMPSTUBS_C       REQUIRED_VARS C_COMPILER_SUPPORTS_OMPSTUBS  )
  find_package_handle_standard_args( OMPSTUBS_CXX     REQUIRED_VARS CXX_COMPILER_SUPPORTS_OMPSTUBS )
  find_package_handle_standard_args( OMPSTUBS_Fortran REQUIRED_VARS Fortran_COMPILER_SUPPORTS_OMPSTUBS )
  set( OMPSTUBS_Fortran_FOUND ${OMPSTUBS_FORTRAN_FOUND} CACHE INTERNAL "")

endmacro( ecbuild_find_omp )

macro( ecbuild_enable_omp )

  ecbuild_find_omp()

  if( OMP_C_FOUND )
    list( APPEND CMAKE_C_FLAGS ${OMP_C_FLAGS} )
  endif()

  if( OMP_CXX_FOUND )
    list( APPEND CMAKE_CXX_FLAGS ${OMP_CXX_FLAGS} )
  endif()

  if( OMP_Fortran_FOUND )
      list( APPEND CMAKE_Fortran_FLAGS ${OMP_Fortran_FLAGS} )
  endif()

endmacro( ecbuild_enable_omp )

macro( ecbuild_enable_ompstubs )

  ecbuild_find_omp()

  if( OMPSTUBS_C_FOUND )
    list( APPEND CMAKE_C_FLAGS ${OMPSTUBS_C_FLAGS} )
  endif()

  if( OMPSTUBS_CXX_FOUND )
    list( APPEND CMAKE_CXX_FLAGS ${OMPSTUBS_CXX_FLAGS} )
  endif()

  if( OMPSTUBS_Fortran_FOUND )
      list( APPEND CMAKE_Fortran_FLAGS ${OMPSTUBS_Fortran_FLAGS} )
  endif()

endmacro( ecbuild_enable_ompstubs )
