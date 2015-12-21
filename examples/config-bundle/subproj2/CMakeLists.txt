cmake_minimum_required( VERSION 2.8.11 FATAL_ERROR )

project( subproj_2 C )

set( CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/../../../cmake" ${CMAKE_MODULE_PATH} )

if( SUBPROJ2_CONFIG )
    set( ECBUILD_CONFIG ${SUBPROJ2_CONFIG} )
endif()

include( ecbuild_system NO_POLICY_SCOPE )

ecbuild_requires_macro_version( 2.0 )

### open project

ecbuild_declare_project()

ecbuild_debug_var( CMAKE_C_FLAGS )
ecbuild_debug_var( CMAKE_C_FLAGS_DEBUG )
