
configure_file(run-test.sh.in run-test.sh @ONLY)
configure_file(test-CMakeLists.txt CMakeLists.txt COPYONLY)

ecbuild_add_test(
  TARGET     ECBUILD-359
  TYPE       SCRIPT
  COMMAND    run-test.sh
)

