cmake_minimum_required(VERSION 3.12 FATAL_ERROR)

find_package(ecbuild 3.4 REQUIRED)

project(projectA VERSION 0.1.0 LANGUAGES C)

ecbuild_add_library(
  TARGET projectA
  SOURCES libraryA.h libraryA.c
  PUBLIC_INCLUDES $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}>
  INSTALL_HEADERS LISTED)

ecbuild_install_project(NAME ${PROJECT_NAME})
