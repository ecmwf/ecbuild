# SPDX-FileCopyrightText: 2011- European Centre for Medium-Range Weather Forecasts (ECMWF)
# SPDX-License-Identifier: Apache-2.0

cmake_minimum_required( VERSION 3.18 FATAL_ERROR )

find_package(ecbuild REQUIRED)
project( bar VERSION 1.0.0 LANGUAGES C CXX )

### targets

ecbuild_find_package( NAME foo REQUIRED )

ecbuild_add_library(
    TARGET       baz
    TYPE         OBJECT
    SOURCES      baz.h baz.c
    PRIVATE_LIBS foo
    PUBLIC_INCLUDES
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}>
        $<BUILD_INTERFACE:${CMAKE_CURRENT_BINARY_DIR}>
)

ecbuild_add_library(
    TARGET       bar
    SOURCES      bar.h bar.c
    OBJECTS      baz
    PRIVATE_LIBS  foo
    PUBLIC_INCLUDES
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}>
        $<BUILD_INTERFACE:${CMAKE_CURRENT_BINARY_DIR}>
)

ecbuild_add_library(
    TARGET       zingo
    TYPE         OBJECT
    SOURCES      zingo.h zingo.c
    PRIVATE_LIBS foo
    PUBLIC_INCLUDES
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}>
        $<BUILD_INTERFACE:${CMAKE_CURRENT_BINARY_DIR}>
)

ecbuild_add_executable(
    TARGET     master_bar
    SOURCES    main.cc
    OBJECTS    zingo
    LIBS       bar foo
)

ecbuild_add_test(
    TARGET     test_bar
    SOURCES    test.cc
    OBJECTS    zingo
    PROPERTIES TIMEOUT 60
    LIBS       bar foo
)

ecbuild_install_project( NAME ${PROJECT_NAME} )

ecbuild_print_summary()
