cmake_minimum_required(VERSION 3.18 FATAL_ERROR)

find_package(ecbuild REQUIRED)
project(test_get_test_multidata VERSION 1.0.0 LANGUAGES NONE)

if(NOT TEST_CASE)
  message(FATAL_ERROR "TEST_CASE is required")
endif()

# Verify that a multidata aggregate generated the expected number of unique
# internal download targets and matching invocations in its helper script.
#
# aggregate_target
#   Name passed to ecbuild_get_test_multidata(TARGET).
# expected_count
#   Number of internal download targets and helper-script invocations expected.
function(assert_generated_targets aggregate_target expected_count)
  get_property(directory_targets DIRECTORY PROPERTY BUILDSYSTEM_TARGETS)
  list(FILTER directory_targets INCLUDE REGEX "^__get_data_${aggregate_target}_")
  list(LENGTH directory_targets actual_count)

  if(NOT actual_count EQUAL expected_count)
    message(FATAL_ERROR
      "Expected ${expected_count} generated targets for '${aggregate_target}', "
      "found ${actual_count}: ${directory_targets}")
  endif()

  list(REMOVE_DUPLICATES directory_targets)
  list(LENGTH directory_targets unique_count)
  if(NOT unique_count EQUAL expected_count)
    message(FATAL_ERROR "Generated targets for '${aggregate_target}' are not unique: ${directory_targets}")
  endif()

  file(READ "${CMAKE_CURRENT_BINARY_DIR}/get_data_${aggregate_target}.cmake" generated_script)
  foreach(target IN LISTS directory_targets)
    string(FIND "${generated_script}" "--target ${target}" target_position)
    if(target_position EQUAL -1)
      message(FATAL_ERROR "Generated download script does not invoke target '${target}'")
    endif()
  endforeach()

  string(REGEX MATCHALL "--target __get_data_${aggregate_target}_[^ )\n]+" script_invocations "${generated_script}")
  list(LENGTH script_invocations invocation_count)
  if(NOT invocation_count EQUAL expected_count)
    message(FATAL_ERROR
      "Expected ${expected_count} target invocations for '${aggregate_target}', "
      "found ${invocation_count}: ${script_invocations}")
  endif()
endfunction()

# Verify the target name generated from readable directory and basename
# components, and the hash of the full relative source path.
#
# aggregate_target
#   Name passed to ecbuild_get_test_multidata(TARGET).
# source_path
#   Relative source path passed as an entry in NAMES, without a checksum.
function(assert_generated_target_name aggregate_target source_path)

  #
  # Important:
  #   The following algorithm MUST match the one in ecbuild_get_test_multidata.cmake
  #   to ensure that the generated target name is correct.
  #
  # The steps are:
  #   1. Split the source path into a directory and a filename.
  #   2. Convert the directory and filename into C identifiers.
  #   3. Compute the MD5 hash of the full source path.
  #   4. Define that expecte target, from:
  #      - "__get_data_" prefix
  #      - aggregate target
  #      - directory identifier
  #      - filename identifier
  #      - and, full source path hash.
  #

  get_filename_component(file "${source_path}" NAME)
  get_filename_component(dir "${source_path}" PATH)
  if(dir)
    string(MAKE_C_IDENTIFIER "${dir}" dir_cidentifier)
    string(APPEND dir_cidentifier "_")
  else()
    set(dir_cidentifier "")
  endif()
  string(MAKE_C_IDENTIFIER "${file}" file_cidentifier)
  string(MD5 dir_file_hash "${source_path}")
  set(expected_target "__get_data_${aggregate_target}_${dir_cidentifier}${file_cidentifier}_${dir_file_hash}")

  if(NOT TARGET ${expected_target})
    message(FATAL_ERROR "Expected target '${expected_target}' was not created for '${source_path}'")
  endif()
  if(expected_target MATCHES "[=,?^;]")
    message(FATAL_ERROR "Generated target '${expected_target}' contains an unsupported character")
  endif()
endfunction()

if(TEST_CASE STREQUAL "supported_names")
  set(supported_names
    foo.grib
    archive.tar.gz
    README
    .config
    a-b.grib
    a+b.grib
    a_b.grib
    a,b.grib
    a=b.grib
    ,a.grib
    b=.grib
    a?.grib
    b^c.grib
    c|d.grib
    e!f.grib
    foo/1.txt
    foo/_1.txt
    bar/other.txt
  )
  ecbuild_get_test_multidata(
    TARGET supported_names
    NAMES ${supported_names}
    NOCHECK
  )
  list(LENGTH supported_names supported_name_count)
  assert_generated_targets(supported_names ${supported_name_count})
  foreach(source_path IN LISTS supported_names)
    assert_generated_target_name(supported_names "${source_path}")
  endforeach()

elseif(TEST_CASE STREQUAL "checksum_options")
  set(checksum "d41d8cd98f00b204e9800998ecf8427e")
  ecbuild_get_test_multidata(
    TARGET inline_checksum
    NAMES checked.data:${checksum}
  )
  assert_generated_targets(inline_checksum 1)

  ecbuild_get_test_multidata(
    TARGET no_checksum
    NAMES unchecked.data
    NOCHECK
  )
  assert_generated_targets(no_checksum 1)

elseif(TEST_CASE STREQUAL "punctuation_in_relative_filenames")
  set(relative_filenames
    foo/a,b.grib
    bar/a=b.grib
    baz/,c.grib
    qux/d=.grib
    question/a?.grib
    caret/b^c.grib
    pipe/c|d.grib
    bang/e!f.grib
    nested/deep/gridType,regular_ll.grib
    nested/other/gridType=regular_ll,scanningMode=96.grib
  )
  ecbuild_get_test_multidata(
    TARGET punctuation_in_relative_filenames
    NAMES ${relative_filenames}
    NOCHECK
  )
  list(LENGTH relative_filenames relative_filename_count)
  assert_generated_targets(punctuation_in_relative_filenames ${relative_filename_count})
  foreach(source_path IN LISTS relative_filenames)
    assert_generated_target_name(punctuation_in_relative_filenames "${source_path}")
  endforeach()

elseif(TEST_CASE STREQUAL "punctuation_in_relative_directories")
  set(relative_directories
    foo,bar/a.grib
    foo=bar/b.grib
    ,foo/c.grib
    bar=/d.grib
    question?/g.grib
    caret^dir/h.grib
    pipe|dir/i.grib
    bang!dir/j.grib
    nested,dir/child=dir/e.grib
    nested=dir/child,dir/f.grib
    nested/de^p/gridType,regular_ll.grib
    nested/oth&r/gridType=regular_ll,scanningMode=96.grib
  )
  ecbuild_get_test_multidata(
    TARGET punctuation_in_relative_directories
    NAMES ${relative_directories}
    NOCHECK
  )
  list(LENGTH relative_directories relative_directory_count)
  assert_generated_targets(punctuation_in_relative_directories ${relative_directory_count})
  foreach(source_path IN LISTS relative_directories)
    assert_generated_target_name(punctuation_in_relative_directories "${source_path}")
  endforeach()

elseif(TEST_CASE STREQUAL "semicolon_in_path")
  # Semicolons are CMake list separators. Even when escaped in the source
  # list, expansion through the multidata argument chain splits these paths.
  set(semicolon_paths
    "semi\;colon.grib"
    "semi\;dir/nested.grib"
  )
  ecbuild_get_test_multidata(
    TARGET semicolon_in_path
    NAMES ${semicolon_paths}
    NOCHECK
  )
  assert_generated_targets(semicolon_in_path 2)
  foreach(source_path IN LISTS semicolon_paths)
    assert_generated_target_name(semicolon_in_path "${source_path}")
  endforeach()

elseif(TEST_CASE STREQUAL "brackets_in_filename")
  # Unquoted unmatched opening and closing brackets are combined by CMake's
  # argument parser rather than forwarded as two independent filenames.
  set(bracket_filenames
    c[d.grib
    c]d.grib
  )
  ecbuild_get_test_multidata(
    TARGET brackets_in_filename
    NAMES ${bracket_filenames}
    NOCHECK
  )
  assert_generated_targets(brackets_in_filename 2)

elseif(TEST_CASE STREQUAL "duplicate_basename")
  ecbuild_get_test_multidata(
    TARGET duplicate_basename
    NAMES foo/a.txt bar/a.txt
    NOCHECK
  )

elseif(TEST_CASE STREQUAL "dot_underscore_collision")
  ecbuild_get_test_multidata(
    TARGET dot_underscore_collision
    NAMES a.b a_b
    NOCHECK
  )
  assert_generated_targets(dot_underscore_collision 2)
  assert_generated_target_name(dot_underscore_collision "a.b")
  assert_generated_target_name(dot_underscore_collision "a_b")

elseif(TEST_CASE STREQUAL "equals_in_filename")
  ecbuild_get_test_multidata(
    TARGET equals_in_filename
    NAMES gridType=regular_ll.grib
    NOCHECK
  )
  assert_generated_targets(equals_in_filename 1)
  assert_generated_target_name(equals_in_filename "gridType=regular_ll.grib")

elseif(TEST_CASE STREQUAL "comma_in_filename")
  ecbuild_get_test_multidata(
    TARGET comma_in_filename
    NAMES gridType,regular_ll.grib
    NOCHECK
  )
  assert_generated_targets(comma_in_filename 1)
  assert_generated_target_name(comma_in_filename "gridType,regular_ll.grib")

elseif(TEST_CASE STREQUAL "multiple_invalid_characters")
  ecbuild_get_test_multidata(
    TARGET multiple_invalid_characters
    NAMES gridType=regular_ll,scanningMode=96.grib
    NOCHECK
  )
  assert_generated_targets(multiple_invalid_characters 1)
  assert_generated_target_name(multiple_invalid_characters "gridType=regular_ll,scanningMode=96.grib")

else()
  message(FATAL_ERROR "Unknown TEST_CASE '${TEST_CASE}'")
endif()
