# SPDX-FileCopyrightText: 2026- European Centre for Medium-Range Weather Forecasts (ECMWF)
# SPDX-License-Identifier: Apache-2.0

cmake_minimum_required(VERSION 3.18 FATAL_ERROR)

find_package(ecbuild REQUIRED)
project(command_dependencies VERSION 0.1 LANGUAGES NONE)

file(WRITE "${CMAKE_CURRENT_BINARY_DIR}/input.txt" "initial input\n")
add_custom_command(
  OUTPUT "${CMAKE_CURRENT_BINARY_DIR}/prerequisite.txt"
  COMMAND ${CMAKE_COMMAND} -E copy
    "${CMAKE_CURRENT_BINARY_DIR}/input.txt"
    "${CMAKE_CURRENT_BINARY_DIR}/prerequisite.txt"
  DEPENDS "${CMAKE_CURRENT_BINARY_DIR}/input.txt"
)
add_custom_target(test_prerequisite
  DEPENDS "${CMAKE_CURRENT_BINARY_DIR}/prerequisite.txt"
)

ecbuild_add_test(
  TARGET command_with_dependencies
  TYPE SCRIPT
  COMMAND ${CMAKE_COMMAND}
  ARGS -E touch "${CMAKE_CURRENT_BINARY_DIR}/test-ran.txt"
  DEPENDS test_prerequisite
)
