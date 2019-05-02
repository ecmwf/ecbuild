cmake_minimum_required(VERSION 3.6 FATAL_ERROR)

include( ecbuild )
project( projectA VERSION 1.1.0 LANGUAGES CXX )

ecbuild_add_library( TARGET projectA_Private SOURCES libraryA_Private.cc )

ecbuild_add_library( TARGET projectA SOURCES libraryA.h libraryA.cc INSTALL_HEADERS LISTED PRIVATE_LIBS projectA_Private )

ecbuild_install_project( NAME ${PROJECT_NAME} )
