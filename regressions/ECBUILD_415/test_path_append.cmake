cmake_minimum_required( VERSION 3.6 FATAL_ERROR )

find_package( ecbuild REQUIRED )
include( ecbuild_append_to_rpath )

unset( SOME_PATH )

ecbuild_path_append( SOME_PATH "/usr/local/foo" )

message( "${SOME_PATH}" )

ecbuild_path_append( SOME_PATH "/usr/bar" )

message( "${SOME_PATH}" )

ecbuild_path_append( SOME_PATH "/system/baz" )

message( "${SOME_PATH}" )

if( NOT "${SOME_PATH}" STREQUAL "/usr/local/foo;/usr/bar;/system/baz" )
  message( FATAL_ERROR "ecbuild_path_append() not working as expected" )
endif()
