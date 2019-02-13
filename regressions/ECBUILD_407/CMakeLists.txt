
configure_file( run-test.sh.in run-test.sh @ONLY )

ecbuild_add_test(
  TARGET     ECBUILD-407
  TYPE       SCRIPT
  COMMAND    run-test.sh
)

