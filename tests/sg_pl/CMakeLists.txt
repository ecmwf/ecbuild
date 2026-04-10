ecbuild_find_perl( REQUIRED )

set(_dir ${CMAKE_CURRENT_BINARY_DIR})
configure_file(run-test.sh.in ${_dir}/run-test.sh @ONLY)

ecbuild_add_test(
  TARGET  test_sg_pl
  TYPE    SCRIPT
  COMMAND run-test.sh
)
