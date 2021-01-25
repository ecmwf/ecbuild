set(_dir ${CMAKE_CURRENT_BINARY_DIR})
configure_file(run-test.sh.in ${_dir}/run-test.sh @ONLY)
configure_file(test_ecbuild_add_flags.cmake ${_dir}/CMakeLists.txt COPYONLY)

ecbuild_add_test(
  TARGET     test_ecbuild_add_flags
  TYPE       SCRIPT
  COMMAND    run-test.sh
)