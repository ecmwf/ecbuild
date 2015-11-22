cmake_minimum_required( VERSION 2.8.12 FATAL_ERROR )

project( foo )

set( CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/cmake" ${CMAKE_MODULE_PATH} "${CMAKE_CURRENT_SOURCE_DIR}/../ecbuild/cmake")

include( ecbuild_system NO_POLICY_SCOPE )

ecbuild_requires_macro_version( 1.9 )

### open project

ecbuild_declare_project()

### targets

set( FOO_INCLUDE_DIRS ${CMAKE_CURRENT_SOURCE_DIR} )

ecbuild_add_library(TARGET       foo
                    SOURCES      foo.h foo.c
                    INCLUDES     ${FOO_INCLUDE_DIRS} )

ecbuild_add_executable(
    TARGET      master_foo
    SOURCES     main.cc
    LIBS        foo
    INCLUDES    ${FOO_INCLUDE_DIRS}  )

ecbuild_add_test(
    TARGET      test_foo
    SOURCES     test.cc
    LIBS        foo
    INCLUDES    ${FOO_INCLUDE_DIRS}  )

ecbuild_install_project( NAME ${PROJECT_NAME} )

ecbuild_print_summary()

