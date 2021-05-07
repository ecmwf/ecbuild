cmake_minimum_required(VERSION 3.12 FATAL_ERROR)

find_package(ecbuild 3.4 REQUIRED)

project(projectC VERSION 0.1.0 LANGUAGES C)

find_package(projectB REQUIRED)

ecbuild_add_executable(
  TARGET main
  SOURCES main.c
  LIBS projectB)

ecbuild_install_project(NAME ${PROJECT_NAME})
