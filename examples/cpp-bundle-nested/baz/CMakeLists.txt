cmake_minimum_required( VERSION 3.11 FATAL_ERROR )

find_package( ecbuild REQUIRED )
project( baz VERSION 1.0.0 LANGUAGES C CXX )

### targets

ecbuild_find_package( NAME foo REQUIRED )

ecbuild_add_library( TARGET            baz
                     SOURCES           baz.h baz.c
                     PUBLIC_LIBS       foo
                     PUBLIC_INCLUDES
                        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}> )

ecbuild_add_executable(
    TARGET     master_baz
    SOURCES    main.cc
    LIBS       baz
)

ecbuild_add_test(
    TARGET     test_baz
    SOURCES    test.cc
    LIBS       baz
)

ecbuild_install_project( NAME ${PROJECT_NAME} )

ecbuild_print_summary()
