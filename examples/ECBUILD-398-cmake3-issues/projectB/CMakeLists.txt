cmake_minimum_required(VERSION 3.6 FATAL_ERROR)

project( projectB VERSION 0.1.0 LANGUAGES CXX )

include( ecbuild_system NO_POLICY_SCOPE )

ecbuild_requires_macro_version( 2.9.5 )
ecbuild_declare_project()

find_package( projectA REQUIRED )

ecbuild_add_library( TARGET projectB SOURCES libraryB.cc libraryB.h INSTALL_HEADERS LISTED )

# BUG: Cannot use PUBLIC here because projectB does not export projectA
set( EXPORT PRIVATE CACHE STRING "" )
target_link_libraries( projectB ${EXPORT} projectA )

ecbuild_install_project( NAME ${PROJECT_NAME} )
