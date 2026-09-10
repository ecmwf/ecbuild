# SPDX-FileCopyrightText: 2011- European Centre for Medium-Range Weather Forecasts (ECMWF)
# SPDX-License-Identifier: Apache-2.0

ecbuild_add_test(
  TARGET     test_ecbuild_project_options_cached_multiproject
  TYPE       SCRIPT
  COMMAND    ${CMAKE_CURRENT_SOURCE_DIR}/configure.sh
  ENVIRONMENT CMAKE_CURRENT_SOURCE_DIR=${CMAKE_CURRENT_SOURCE_DIR} CMAKE_CURRENT_BINARY_DIR=${CMAKE_CURRENT_BINARY_DIR}
)
