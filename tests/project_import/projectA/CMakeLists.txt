cmake_minimum_required(VERSION 3.12 FATAL_ERROR)

find_package(ecbuild 3.4 REQUIRED)

project(projectA VERSION 0.0 LANGUAGES C)

set(projectA_FOO foo)
set(projectA_BAR bar)

ecbuild_add_library(TARGET libA SOURCES libA.c)

ecbuild_install_project(NAME ${PROJECT_NAME})
