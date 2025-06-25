cmake_minimum_required( VERSION 3.18 FATAL_ERROR )

find_package(ecbuild 3.0 REQUIRED )

project( mylib VERSION 0.1.0 LANGUAGES NONE )

ecbuild_install_project( NAME ${PROJECT_NAME} )
