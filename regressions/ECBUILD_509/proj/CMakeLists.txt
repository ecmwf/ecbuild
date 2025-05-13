cmake_minimum_required( VERSION 3.18 FATAL_ERROR )

find_package(ecbuild 3.6 QUIET)
project(myproj VERSION 0.1.0 LANGUAGES C)

ecbuild_add_library(TARGET mylib SOURCES mylib.c)

ecbuild_add_test(
    TARGET myexe 
    SOURCES myexe.c 
    PROPERTIES TIMEOUT 60 
    LIBS mylib
)

ecbuild_install_project( NAME ${PROJECT_NAME} )
