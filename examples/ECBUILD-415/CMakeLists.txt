cmake_minimum_required( VERSION 2.8.12 FATAL_ERROR )

project( test_paths C )

set( CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} "${CMAKE_CURRENT_SOURCE_DIR}/../../cmake" )

include( ecbuild_system NO_POLICY_SCOPE )

ecbuild_requires_macro_version( 2.9 )

### open project

ecbuild_declare_project()

message( "${CMAKE_INSTALL_RPATH}" )

ecbuild_path_append( CMAKE_INSTALL_RPATH "/usr/local/foo" )

message( "${CMAKE_INSTALL_RPATH}" )

ecbuild_path_append( CMAKE_INSTALL_RPATH "/usr/bar" )

message( "${CMAKE_INSTALL_RPATH}" )

ecbuild_path_append( CMAKE_INSTALL_RPATH "/system/baz" )

message( "${CMAKE_INSTALL_RPATH}" )

ecbuild_print_summary()
