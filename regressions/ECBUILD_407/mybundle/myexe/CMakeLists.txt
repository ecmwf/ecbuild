cmake_minimum_required(VERSION 3.6 FATAL_ERROR)

project( myexe VERSION 0.1.0 LANGUAGES NONE )

include( ecbuild_system NO_POLICY_SCOPE )

ecbuild_requires_macro_version( 2.9.5 )
ecbuild_declare_project()

ecbuild_find_package( NAME mylib REQUIRED )

if( NOT DEFINED mylib_FOO )
  message( FATAL_ERROR "mylib_FOO is not defined" )
endif()

ecbuild_install_project( NAME ${PROJECT_NAME} )
