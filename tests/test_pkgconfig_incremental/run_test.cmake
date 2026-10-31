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
  -S "${TEST_SOURCE_DIR}/test_project" -B "${build_dir}"
  -G "${TEST_GENERATOR}"
  "-DCMAKE_MAKE_PROGRAM=${TEST_MAKE_PROGRAM}"
  "-Decbuild_ROOT=${ecbuild_ROOT}"
  -DENABLE_PKGCONFIG=ON
)
set(pc_file "${build_dir}/lib/pkgconfig/example.pc")
run_checked("${CMAKE_COMMAND}" --build "${build_dir}" --verbose)
if(NOT EXISTS "${pc_file}")
  message(FATAL_ERROR "The default build did not generate example.pc")
endif()
if(NOT EXISTS "${build_dir}/lib/pkgconfig/example_sub.pc")
  message(FATAL_ERROR "The default build did not generate example_sub.pc from a subdirectory")
endif()
file(READ "${pc_file}" original_content)
file(TIMESTAMP "${pc_file}" original_time "%s")

run_checked("${CMAKE_COMMAND}" -E sleep 2)
run_checked("${CMAKE_COMMAND}" --build "${build_dir}" --verbose)
set(noop_output "${command_output}")
file(TIMESTAMP "${pc_file}" noop_time "%s")

# Both inputs to the generation command must invalidate its output.
run_checked("${CMAKE_COMMAND}" -E sleep 2)
file(APPEND "${build_dir}/example.pc.tmp" "\n# Template update\n")
run_checked("${CMAKE_COMMAND}" --build "${build_dir}" --verbose)
file(READ "${pc_file}" template_content)
if(NOT template_content STREQUAL "${original_content}\n# Template update\n")
  message(FATAL_ERROR "The configured template change was not propagated")
endif()

run_checked("${CMAKE_COMMAND}" -E sleep 2)
file(APPEND "${build_dir}/example.pc-pkg-config-build.cmake"
  "\nfile(APPEND \"${pc_file}\" \"# Script update\\n\")\n")
run_checked("${CMAKE_COMMAND}" --build "${build_dir}" --verbose)
file(READ "${pc_file}" script_content)
if(NOT script_content STREQUAL "${template_content}# Script update\n")
  message(FATAL_ERROR "The generation script change was not propagated")
endif()

file(REMOVE "${pc_file}")
run_checked("${CMAKE_COMMAND}" --build "${build_dir}" --verbose)
if(NOT EXISTS "${pc_file}")
  message(FATAL_ERROR "A missing pkg-config output was not regenerated")
endif()
file(READ "${pc_file}" regenerated_content)
if(NOT regenerated_content STREQUAL script_content)
  message(FATAL_ERROR "The regenerated pkg-config output has incorrect content")
endif()

if(NOT original_time STREQUAL noop_time OR
   noop_output MATCHES "-P[^\n]*example\\.pc-pkg-config-build\\.cmake")
  message(FATAL_ERROR
    "The no-op build regenerated the pkg-config file:\n${noop_output}")
endif()
