
set( _ref ${CMAKE_CURRENT_BINARY_DIR} )

set( mybundle_SOURCE_DIR ${CMAKE_CURRENT_SOURCE_DIR}/mybundle )
configure_file( run-test.sh.in ${_ref}/run-test.sh @ONLY )

ecbuild_add_test(
  TARGET     bundle-subproj
  TYPE       SCRIPT
  COMMAND    ${_ref}/run-test.sh
)
