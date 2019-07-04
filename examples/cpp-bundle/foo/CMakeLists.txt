cmake_minimum_required( VERSION 3.6 FATAL_ERROR )

find_package(ecbuild REQUIRED)
project( foo VERSION 1.0.0 LANGUAGES C CXX )

### targets

set( FOO_INCLUDE_DIRS ${CMAKE_CURRENT_SOURCE_DIR} )

ecbuild_add_library(
    TARGET           foo
    SOURCES          foo.h foo.c
    INSTALL_HEADERS  LISTED
    PUBLIC_INCLUDES
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}>
        $<BUILD_INTERFACE:${CMAKE_CURRENT_BINARY_DIR}> )

ecbuild_add_executable(
    TARGET      master_foo
    SOURCES     main.cc
    LIBS        foo )

ecbuild_add_test(
    TARGET      test_foo
    SOURCES     test.cc
    LIBS        foo )

ecbuild_install_project( NAME ${PROJECT_NAME} )

ecbuild_print_summary()

