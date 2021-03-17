
configure_file( run.sh.in run.sh @ONLY )

ecbuild_add_test(
  TARGET     ECBUILD-509
  TYPE       SCRIPT
  COMMAND    run.sh
)

