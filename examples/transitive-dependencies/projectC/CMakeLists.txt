cmake_minimum_required( VERSION 3.18 FATAL_ERROR )

find_package( ecbuild REQUIRED )
project( projectC VERSION 0.1.0 LANGUAGES CXX )

find_package( projectB REQUIRED )

ecbuild_add_library( TARGET projectC SOURCES libraryC.cc libraryC.h INSTALL_HEADERS LISTED PRIVATE_LIBS projectB )

ecbuild_add_executable( TARGET main-C SOURCES main.cc LIBS projectC )

ecbuild_install_project( NAME ${PROJECT_NAME} )
