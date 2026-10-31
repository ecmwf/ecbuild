# (C) Copyright 2026- ECMWF.
#
# This software is licensed under the terms of the Apache Licence Version 2.0
# which can be obtained at http://www.apache.org/licenses/LICENSE-2.0.
# In applying this licence, ECMWF does not waive the privileges and immunities
# granted to it by virtue of its status as an intergovernmental organisation nor
# does it submit to any jurisdiction.

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
