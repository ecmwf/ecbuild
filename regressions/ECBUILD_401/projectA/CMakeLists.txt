cmake_minimum_required( VERSION 3.18 FATAL_ERROR )

find_package(ecbuild QUIET)
project( projectA VERSION 0.1.0 LANGUAGES CXX )

include( ecbuild_system NO_POLICY_SCOPE )

ecbuild_requires_macro_version( 2.9.5 )
ecbuild_declare_project()

ecbuild_add_library( TARGET projectA SOURCES libraryA.h libraryA.cc INSTALL_HEADERS LISTED )

ecbuild_install_project( NAME ${PROJECT_NAME} )
