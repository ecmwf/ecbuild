set(_dir ${CMAKE_CURRENT_BINARY_DIR})
configure_file(run-test.sh.in ${_dir}/run-test.sh @ONLY)
configure_file(test_ecbuild_override_compiler_flags_bailout.cmake ${_dir}/CMakeLists.txt COPYONLY)
configure_file(compiler_flags.cmake ${_dir}/compiler_flags.cmake COPYONLY)
configure_file(emptyfile.F90 ${_dir}/emptyfile.F90 COPYONLY)

ecbuild_add_test(
  TARGET     test_ecbuild_override_compiler_flags_bailout
  TYPE       SCRIPT
  COMMAND    run-test.sh
)
