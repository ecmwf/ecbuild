
ecbuild_add_test(
  TARGET     test_ecbuild_project_summary
  TYPE       SCRIPT
  COMMAND    ${CMAKE_CURRENT_SOURCE_DIR}/configure.sh
  ENVIRONMENT CMAKE_CURRENT_SOURCE_DIR=${CMAKE_CURRENT_SOURCE_DIR} CMAKE_CURRENT_BINARY_DIR=${CMAKE_CURRENT_BINARY_DIR}
)
