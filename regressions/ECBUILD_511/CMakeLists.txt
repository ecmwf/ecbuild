
set( ec511_res clean.sh )

configure_file( run-test.sh.in run-test.sh @ONLY )

ecbuild_add_test(
  TARGET     ECBUILD-511
  TYPE       SCRIPT
  COMMAND    run-test.sh
  RESOURCES  ${ec511_res}
)

