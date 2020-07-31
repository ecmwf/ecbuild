
set( _ref ${CMAKE_CURRENT_BINARY_DIR} )

set( bundle_SOURCE_DIR ${CMAKE_CURRENT_SOURCE_DIR}/bundle )
configure_file( run-test.sh.in ${_ref}/run-test.sh @ONLY )

ecbuild_add_test(
  TARGET     bundle-override-features
  TYPE       SCRIPT
  COMMAND    ${_ref}/run-test.sh
)
