cmake_minimum_required(VERSION 3.12 FATAL_ERROR)

find_package(ecbuild 3.4 REQUIRED)

project(projectB VERSION 0.1.0 LANGUAGES C)

find_package(projectA REQUIRED)

ecbuild_add_library(
  TARGET projectB
  SOURCES libraryB.h libraryB.c
  PUBLIC_LIBS projectA
  PUBLIC_INCLUDES $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}>
  INSTALL_HEADERS LISTED)

ecbuild_install_project(NAME ${PROJECT_NAME})
