
set( _ref ${CMAKE_CURRENT_BINARY_DIR} )

set( projectA_SOURCE_DIR ${CMAKE_CURRENT_SOURCE_DIR}/projectA )
set( projectB_SOURCE_DIR ${CMAKE_CURRENT_SOURCE_DIR}/projectB )
set( projectC_SOURCE_DIR ${CMAKE_CURRENT_SOURCE_DIR}/projectC )
configure_file( run-test.sh.in ${_ref}/run-test.sh @ONLY )

ecbuild_add_test(
  TARGET     project_import
  TYPE       SCRIPT
  COMMAND    ${_ref}/run-test.sh
)
