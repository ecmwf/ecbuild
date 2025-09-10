cmake_minimum_required( VERSION 3.18 FATAL_ERROR )

find_package(ecbuild 3.4 REQUIRED)

project(projectB VERSION 0.0 LANGUAGES C)

ecbuild_add_library(TARGET libB SOURCES libB.c)

ecbuild_install_project(NAME ${PROJECT_NAME})
