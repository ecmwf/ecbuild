cmake_minimum_required( VERSION 3.18 FATAL_ERROR )

find_package( ecbuild REQUIRED )
project( projectA VERSION 1.1.0 LANGUAGES CXX )

ecbuild_add_library( TARGET projectA_Private SOURCES libraryA_Private.cc PRIVATE_DEFINITIONS A_PRIVATE PUBLIC_DEFINITIONS A_PUBLIC )

ecbuild_add_library( TARGET projectA SOURCES libraryA.h libraryA.cc INSTALL_HEADERS LISTED PRIVATE_LIBS projectA_Private PUBLIC_DEFINITIONS A_EXPORT )

ecbuild_install_project( NAME ${PROJECT_NAME} )
