# SPDX-FileCopyrightText: 2011- European Centre for Medium-Range Weather Forecasts (ECMWF)
# SPDX-License-Identifier: Apache-2.0

ecbuild_add_test(
  TARGET     test_ecbuild_install_dependency_with_soversion
  TYPE       SCRIPT
  COMMAND    ${CMAKE_CURRENT_SOURCE_DIR}/run-test.sh
  WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
)

