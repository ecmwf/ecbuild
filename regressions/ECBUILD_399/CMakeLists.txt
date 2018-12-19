
configure_file( run-test.sh.in run-test.sh @ONLY )

ecbuild_add_test(
  TARGET     ECBUILD-399
  TYPE       SCRIPT
  COMMAND    run-test.sh
)

