
configure_file( run.sh.in run.sh @ONLY )

ecbuild_add_test(
  TARGET     ECBUILD-495
  TYPE       SCRIPT
  COMMAND    run.sh
)

