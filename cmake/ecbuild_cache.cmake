# (C) Copyright 1996-2014 ECMWF.
# 
# This software is licensed under the terms of the Apache Licence Version 2.0
# which can be obtained at http://www.apache.org/licenses/LICENSE-2.0. 
# In applying this licence, ECMWF does not waive the privileges and immunities 
# granted to it by virtue of its status as an intergovernmental organisation nor
# does it submit to any jurisdiction.


set( ecbuild_cache_file ${CMAKE_BINARY_DIR}/ecbuild-cache.cmake )
file(WRITE ${ecbuild_cache_file} "# ecbuild toolchain file\n\n")

function( ecbuild_cache_var var )
  if( NOT ${var} )
    set( ${var} 0 )
  endif()
  file( APPEND ${ecbuild_cache_file} "set( ${var} ${${var}} )\n" )
endfunction()

function( ecbuild_cache_check_symbol_exists symbol includes output )
  if( NOT DEFINED ${output} )
    check_symbol_exists( ${symbol} ${includes} ${output} )
  endif()
  ecbuild_cache_var( ${output} )
endfunction()

function( ecbuild_cache_check_include_files includes output )
  if( NOT DEFINED ${output} )
    check_include_files( ${includes} ${output} )
  endif()
  ecbuild_cache_var( ${output} )
endfunction()

function( ecbuild_cache_check_c_source_compiles source output )
  if( NOT DEFINED ${output} )
    check_c_source_compiles( "${source}" ${output} )
  endif()
  ecbuild_cache_var( ${output} )
endfunction()

function( ecbuild_cache_check_cxx_source_compiles source output )
  if( NOT DEFINED ${output} )
    check_cxx_source_compiles( "${source}" ${output} )
  endif()
  ecbuild_cache_var( ${output} )
endfunction()

function( ecbuild_cache_check_type_size type output )
  if( NOT DEFINED ${output} )
    check_cxx_source_compiles( "${type}" ${output} )
  endif()
  ecbuild_cache_var( ${output} )
endfunction()