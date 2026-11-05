# SPDX-FileCopyrightText: 2026- European Centre for Medium-Range Weather Forecasts (ECMWF)
# SPDX-License-Identifier: Apache-2.0

ecbuild_add_test(
  TARGET test_ecbuild_command_dependencies
  TYPE SCRIPT
  COMMAND ${CMAKE_COMMAND}
  ARGS
    -DTEST_SOURCE_DIR=${CMAKE_CURRENT_SOURCE_DIR}
    -DTEST_BINARY_DIR=${CMAKE_CURRENT_BINARY_DIR}
    -Decbuild_ROOT=${PROJECT_SOURCE_DIR}
    -DTEST_GENERATOR=${CMAKE_GENERATOR}
    -DTEST_MAKE_PROGRAM=${CMAKE_MAKE_PROGRAM}
    -P ${CMAKE_CURRENT_SOURCE_DIR}/run_test.cmake
)
