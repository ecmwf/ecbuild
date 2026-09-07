cmake_minimum_required(VERSION 3.18 FATAL_ERROR)

function(run_configure_case case_name expected_result expected_error)
  set(build_dir "${TEST_BINARY_DIR}/${case_name}")
  file(REMOVE_RECURSE "${build_dir}")

  execute_process(
    COMMAND
      "${CMAKE_COMMAND}"
      -S "${TEST_SOURCE_DIR}/test_project"
      -B "${build_dir}"
      -Decbuild_ROOT=${ecbuild_ROOT}
      -DTEST_CASE=${case_name}
    RESULT_VARIABLE result
    OUTPUT_VARIABLE stdout
    ERROR_VARIABLE stderr
  )

  set(output "${stdout}${stderr}")
  if(expected_result STREQUAL "success")
    if(NOT result EQUAL 0)
      message(FATAL_ERROR
        "Case '${case_name}' should configure successfully, but returned ${result}:\n${output}")
    endif()
  elseif(expected_result STREQUAL "failure")
    if(result EQUAL 0)
      message(FATAL_ERROR "Case '${case_name}' should fail to configure, but succeeded")
    endif()
    if(NOT output MATCHES "${expected_error}")
      message(FATAL_ERROR
        "Case '${case_name}' failed without the expected diagnostic '${expected_error}':\n${output}")
    endif()
  else()
    message(FATAL_ERROR "Unknown expected result '${expected_result}' for case '${case_name}'")
  endif()
endfunction()

# Existing supported inputs must continue to generate distinct download targets.
run_configure_case(supported_names success "")
run_configure_case(checksum_options success "")

# Existing limitations are isolated so each failure mode remains observable.
run_configure_case(duplicate_basename failure "target.*already exists")
run_configure_case(dot_underscore_collision failure "target.*already exists")
run_configure_case(equals_in_filename failure "target name.*not valid")
run_configure_case(comma_in_filename failure "target name.*not valid")
run_configure_case(multiple_invalid_characters failure "target name.*not valid")
