# (C) Copyright 2026- ECMWF.
#
# This software is licensed under the terms of the Apache Licence Version 2.0
# which can be obtained at http://www.apache.org/licenses/LICENSE-2.0.
# In applying this licence, ECMWF does not waive the privileges and immunities
# granted to it by virtue of its status as an intergovernmental organisation nor
# does it submit to any jurisdiction.

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
