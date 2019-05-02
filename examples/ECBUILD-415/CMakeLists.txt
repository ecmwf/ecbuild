cmake_minimum_required( VERSION 3.6 FATAL_ERROR )

set( CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} "${CMAKE_CURRENT_SOURCE_DIR}/../../cmake" )

include( ecbuild )
project( test_paths C )

### open project

ecbuild_declare_project()

message( "${SOME_PATH}" )

ecbuild_path_append( SOME_PATH "/usr/local/foo" )

message( "${SOME_PATH}" )

ecbuild_path_append( SOME_PATH "/usr/bar" )

message( "${SOME_PATH}" )

ecbuild_path_append( SOME_PATH "/system/baz" )

message( "${SOME_PATH}" )

if( NOT "${SOME_PATH}" STREQUAL "/usr/local/foo;/usr/bar;/system/baz" )
  message( FATAL_ERROR "ecbuild_path_append() not working as expected" )
endif()
