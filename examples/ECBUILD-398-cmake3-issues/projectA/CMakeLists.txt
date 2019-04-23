cmake_minimum_required(VERSION 3.6 FATAL_ERROR)

project( projectA VERSION 0.1.0 LANGUAGES CXX )

include( ecbuild_system NO_POLICY_SCOPE )

ecbuild_requires_macro_version( 2.9.5 )
ecbuild_declare_project()

ecbuild_add_library( TARGET projectA_Private SOURCES libraryA_Private.cc )

ecbuild_add_library( TARGET projectA SOURCES libraryA.h libraryA.cc INSTALL_HEADERS LISTED )
target_link_libraries( projectA PRIVATE projectA_Private )

ecbuild_install_project( NAME ${PROJECT_NAME} )
