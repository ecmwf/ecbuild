cmake_minimum_required( VERSION 3.18 FATAL_ERROR )

find_package(ecbuild QUIET)
project( projectB VERSION 0.1.0 LANGUAGES CXX )

include( ecbuild_system NO_POLICY_SCOPE )

ecbuild_requires_macro_version( 2.9.5 )
ecbuild_declare_project()

find_package( projectA REQUIRED )

ecbuild_add_executable( TARGET main SOURCES main.cc )
target_link_libraries( main projectA )

ecbuild_install_project( NAME ${PROJECT_NAME} )
