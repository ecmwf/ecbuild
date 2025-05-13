cmake_minimum_required( VERSION 3.18 FATAL_ERROR )

find_package( ecbuild REQUIRED )
project( projectB VERSION 0.1.0 LANGUAGES CXX )

ecbuild_find_package( NAME projectA REQUIRED QUIET )

ecbuild_add_library( TARGET projectB SOURCES libraryB.cc libraryB.h INSTALL_HEADERS LISTED PUBLIC_LIBS projectA )

ecbuild_install_project( NAME ${PROJECT_NAME} )

ecbuild_debug_var( CMAKE_MODULE_PATH )
ecbuild_debug_var( CMAKE_SYSTEM_MODULE_PATH )