# (C) Copyright 2026- ECMWF.
#
# This software is licensed under the terms of the Apache Licence Version 2.0
# which can be obtained at http://www.apache.org/licenses/LICENSE-2.0.
# In applying this licence, ECMWF does not waive the privileges and immunities
# granted to it by virtue of its status as an intergovernmental organisation nor
# does it submit to any jurisdiction.

cmake_minimum_required(VERSION 3.18 FATAL_ERROR)

set(build_dir "${TEST_BINARY_DIR}/test_project")
file(REMOVE_RECURSE "${build_dir}")

function(run_checked)
  execute_process(
    COMMAND ${ARGN}
    RESULT_VARIABLE result
    OUTPUT_VARIABLE stdout
    ERROR_VARIABLE stderr
  )
  if(NOT result EQUAL 0)
    message(FATAL_ERROR "Command failed (${result}): ${ARGN}\n${stdout}${stderr}")
  endif()
  set(command_output "${stdout}${stderr}" PARENT_SCOPE)
endfunction()

run_checked("${CMAKE_COMMAND}"
  -S "${TEST_SOURCE_DIR}/test_project"
  -B "${build_dir}"
  -G "${TEST_GENERATOR}"
  "-DCMAKE_MAKE_PROGRAM=${TEST_MAKE_PROGRAM}"
  "-Decbuild_ROOT=${ecbuild_ROOT}"
)
run_checked("${CMAKE_COMMAND}" --build "${build_dir}" --verbose)
if(NOT EXISTS "${build_dir}/prerequisite.txt")
  message(FATAL_ERROR "The default build did not generate the test prerequisite")
endif()
if(EXISTS "${build_dir}/test-ran.txt")
  message(FATAL_ERROR "The default build unexpectedly executed the CTest test")
endif()
file(TIMESTAMP "${build_dir}/prerequisite.txt" prerequisite_time "%s")

# Generator-independent detection: the marker must not be updated by a no-op build.
set(marker "${build_dir}/command_with_dependencies.x")
set(marker_time "")
if(EXISTS "${marker}")
  file(TIMESTAMP "${marker}" marker_time "%s")
endif()

# Leave enough time for filesystems with one-second timestamp resolution.
run_checked("${CMAKE_COMMAND}" -E sleep 2)
run_checked("${CMAKE_COMMAND}" --build "${build_dir}" --verbose)
set(noop_output "${command_output}")
set(noop_marker_time "")
if(EXISTS "${marker}")
  file(TIMESTAMP "${marker}" noop_marker_time "%s")
endif()
file(TIMESTAMP "${build_dir}/prerequisite.txt" rebuilt_time "%s")
if(NOT prerequisite_time STREQUAL rebuilt_time)
  message(FATAL_ERROR "The no-op build regenerated the prerequisite:\n${noop_output}")
endif()

get_filename_component(cmake_bin_dir "${CMAKE_COMMAND}" DIRECTORY)
run_checked("${cmake_bin_dir}/ctest"
  --test-dir "${build_dir}" -R "^command_with_dependencies$" --output-on-failure
)
if(NOT EXISTS "${build_dir}/test-ran.txt")
  message(FATAL_ERROR "CTest did not execute the registered test")
endif()

run_checked("${CMAKE_COMMAND}" -E sleep 2)
file(WRITE "${build_dir}/input.txt" "updated input\n")
run_checked("${CMAKE_COMMAND}" --build "${build_dir}" --verbose)
file(READ "${build_dir}/prerequisite.txt" prerequisite)
if(NOT prerequisite STREQUAL "updated input\n")
  message(FATAL_ERROR "The default build did not update the test prerequisite")
endif()

if(NOT marker_time STREQUAL noop_marker_time OR
   noop_output MATCHES "-E touch[^\n]*command_with_dependencies\\.x")
  message(FATAL_ERROR
    "The no-op build executed the command-based test marker:\n${noop_output}")
endif()
