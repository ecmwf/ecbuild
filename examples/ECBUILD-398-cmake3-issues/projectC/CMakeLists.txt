cmake_minimum_required(VERSION 3.6 FATAL_ERROR)

project( projectC VERSION 0.1.0 LANGUAGES CXX )

include( ecbuild_system NO_POLICY_SCOPE )

ecbuild_requires_macro_version( 2.9.5 )
ecbuild_declare_project()

find_package( projectB REQUIRED )

ecbuild_add_library( TARGET projectC SOURCES libraryC.cc libraryC.h INSTALL_HEADERS LISTED )
target_link_libraries( projectC PRIVATE projectB )


ecbuild_add_executable( TARGET main-C SOURCES main.cc )
target_link_libraries( main-C projectC )

ecbuild_install_project( NAME ${PROJECT_NAME} )
