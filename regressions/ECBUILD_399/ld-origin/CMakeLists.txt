cmake_minimum_required(VERSION 3.6 FATAL_ERROR)

project(test_ld_origin VERSION 1.0 LANGUAGES C)

include(ecbuild_system NO_POLICY_SCOPE)

ecbuild_requires_macro_version( 2.9 )
ecbuild_declare_project()

# Allow RPATH to be overridden at build time
# This allows to recreate the bug without having to install a dummy project
set(CMAKE_BUILD_WITH_INSTALL_RPATH TRUE)

ecbuild_add_library(TARGET dso1 SOURCES dso1.c)

ecbuild_add_library(TARGET dso2 SOURCES dso2.c)
target_link_libraries(dso2 PRIVATE dso1)
ecbuild_target_rpath(dso2 REPLACE "../lib")

ecbuild_add_executable(TARGET main SOURCES main.c)
target_link_libraries(main PRIVATE dso2)
ecbuild_target_rpath(main REPLACE "../lib")

ecbuild_install_project(NAME ${PROJECT_NAME})
