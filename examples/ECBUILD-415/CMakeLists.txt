cmake_minimum_required( VERSION 2.8.12 FATAL_ERROR )

project( test_paths C )

set( CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} "${CMAKE_CURRENT_SOURCE_DIR}/../../cmake" )

include( ecbuild_system NO_POLICY_SCOPE )

ecbuild_requires_macro_version( 2.9 )

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
