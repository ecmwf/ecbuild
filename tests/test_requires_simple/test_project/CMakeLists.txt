# SPDX-FileCopyrightText: 2011- European Centre for Medium-Range Weather Forecasts (ECMWF)
# SPDX-License-Identifier: Apache-2.0

cmake_minimum_required( VERSION 3.18 FATAL_ERROR )

find_package( ecbuild REQUIRED )
project( test_test_requires_simple VERSION 0.1.0 LANGUAGES NONE )

ecbuild_add_test(
    TARGET clean_output
    COMMAND ${CMAKE_COMMAND}
    ARGS -E remove ${CMAKE_CURRENT_BINARY_DIR}/output.txt
)

ecbuild_add_test(
    TARGET write_hello
    TEST_REQUIRES clean_output
    COMMAND bash
    ARGS -c "echo -n 'Hello, ' >> ${CMAKE_CURRENT_BINARY_DIR}/output.txt"
)

ecbuild_add_test(
    TARGET write_world_after_hello
    TEST_REQUIRES write_hello
    COMMAND bash
    ARGS -c "echo -n 'World!' >> ${CMAKE_CURRENT_BINARY_DIR}/output.txt"
)
