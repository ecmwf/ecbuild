cmake_minimum_required(VERSION 3.6 FATAL_ERROR)

find_package(ecbuild QUIET)

include( ecbuild_bundle )

project( mybundle VERSION 0.1.0.0 LANGUAGES NONE )

ecbuild_bundle_initialize()

ecbuild_requires_macro_version( 2.9.5 )

add_subdirectory( mylib )
add_subdirectory( myexe )

ecbuild_install_project( NAME ${PROJECT_NAME} )
