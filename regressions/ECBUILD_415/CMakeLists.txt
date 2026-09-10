# SPDX-FileCopyrightText: 2011- European Centre for Medium-Range Weather Forecasts (ECMWF)
# SPDX-License-Identifier: Apache-2.0

ecbuild_add_test(
  TARGET     ECBUILD-415
  TYPE       SCRIPT
  COMMAND    ${CMAKE_COMMAND}
  ARGS       -DCMAKE_MODULE_PATH=${ECBUILD_MACROS_DIR}
             -P ${CMAKE_CURRENT_SOURCE_DIR}/test_path_append.cmake
)
