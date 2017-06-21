cmake_minimum_required( VERSION 2.8.12 FATAL_ERROR )

project( baz C CXX )

set( CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/cmake" ${CMAKE_MODULE_PATH} "${CMAKE_CURRENT_SOURCE_DIR}/../ecbuild/cmake")

include( ecbuild_system NO_POLICY_SCOPE )

ecbuild_requires_macro_version( 2.7 )

### open project

ecbuild_declare_project()

### targets

ecbuild_use_package( PROJECT foo REQUIRED )

ecbuild_add_library( TARGET            baz
                     SOURCES           baz.h baz.c
                     PRIVATE_INCLUDES  ${FOO_INCLUDE_DIRS}
                     LIBS              foo )

ecbuild_add_executable(
    TARGET     master_baz
    SOURCES    main.cc
    INCLUDES   ${FOO_INCLUDE_DIRS}
    LIBS       baz
)

ecbuild_add_test(
    TARGET     test_baz
    SOURCES    test.cc
    LIBS       baz
)

ecbuild_install_project( NAME ${PROJECT_NAME} )

ecbuild_print_summary()
