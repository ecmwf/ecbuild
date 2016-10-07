cmake_minimum_required( VERSION 2.8.12 FATAL_ERROR )

project( bar C )

set( CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} "${CMAKE_CURRENT_SOURCE_DIR}/../ecbuild/cmake" )

include( ecbuild_system NO_POLICY_SCOPE )

ecbuild_requires_macro_version( 2.0 )

### open project

ecbuild_declare_project()

### targets

ecbuild_add_library( TARGET bar SOURCES bar.c )

ecbuild_install_project( NAME ${PROJECT_NAME} )

ecbuild_print_summary()
