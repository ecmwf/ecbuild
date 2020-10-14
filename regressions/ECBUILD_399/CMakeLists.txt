
configure_file( ld-origin.sh.in ld-origin.sh @ONLY )

ecbuild_add_test(
  TARGET     ECBUILD-399-ld-origin
  TYPE       SCRIPT
  COMMAND    ld-origin.sh
  CONDITION  UNIX
)

#[=[
Description of the bug: the linker fix check (look for test_ld_origin in
cmake/ecbuild_check_os.cmake) makes the build fail if two different versions of
ecbuild are used in the same build directory.
#]=]

configure_file( buildfail.sh.in buildfail.sh @ONLY )
configure_file( buildfail-CMakeLists.txt.in buildfail/CMakeLists.txt @ONLY )

ecbuild_add_test(
  TARGET     ECBUILD-399-buildfail
  TYPE       SCRIPT
  COMMAND    buildfail.sh
  CONDITION  UNIX
)

