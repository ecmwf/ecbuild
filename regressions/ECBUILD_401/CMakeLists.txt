
set( ec401_res clean.sh )

configure_file( run-test.sh.in run-test.sh @ONLY )

ecbuild_add_test(
  TARGET     ECBUILD-401
  TYPE       SCRIPT
  COMMAND    run-test.sh
  RESOURCES  ${ec401_res}
)

