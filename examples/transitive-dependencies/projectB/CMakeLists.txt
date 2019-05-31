cmake_minimum_required(VERSION 3.6 FATAL_ERROR)

find_package( ecbuild REQUIRED )
project( projectB VERSION 0.1.0 LANGUAGES CXX )

find_package( projectA REQUIRED )

ecbuild_add_library( TARGET projectB SOURCES libraryB.cc libraryB.h INSTALL_HEADERS LISTED PUBLIC_LIBS projectA )

ecbuild_install_project( NAME ${PROJECT_NAME} )
