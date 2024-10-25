set(_dir ${CMAKE_CURRENT_BINARY_DIR})
configure_file(run-test.sh.in ${_dir}/run-test.sh @ONLY)
configure_file(test_ecbuild_source_flags.cmake ${_dir}/CMakeLists.txt COPYONLY)
configure_file(emptyfile.c ${_dir}/emptyfile.c COPYONLY)
configure_file(emptyfile.cxx ${_dir}/emptyfile.cxx COPYONLY)
configure_file(emptyfile.F90 ${_dir}/emptyfile.F90 COPYONLY)

ecbuild_add_test(
  TARGET     test_ecbuild_source_flags
  TYPE       SCRIPT
  COMMAND    run-test.sh
)
