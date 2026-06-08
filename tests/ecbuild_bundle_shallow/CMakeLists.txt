
ecbuild_add_test(
  TARGET     test_ecbuild_bundle_shallow_recursive
  TYPE       SCRIPT
  COMMAND    ${CMAKE_CURRENT_SOURCE_DIR}/run-test-shallow-recursive.sh
  ENVIRONMENT
    CMAKE_SOURCE_DIR=${CMAKE_SOURCE_DIR}
    CMAKE_CURRENT_SOURCE_DIR=${CMAKE_CURRENT_SOURCE_DIR}
    CMAKE_CURRENT_BINARY_DIR=${CMAKE_CURRENT_BINARY_DIR}
)

ecbuild_add_test(
  TARGET     test_ecbuild_bundle_shallow_no_recursive
  TYPE       SCRIPT
  COMMAND    ${CMAKE_CURRENT_SOURCE_DIR}/run-test-shallow-no-recursive.sh
  ENVIRONMENT
    CMAKE_SOURCE_DIR=${CMAKE_SOURCE_DIR}
    CMAKE_CURRENT_SOURCE_DIR=${CMAKE_CURRENT_SOURCE_DIR}
    CMAKE_CURRENT_BINARY_DIR=${CMAKE_CURRENT_BINARY_DIR}
)

ecbuild_add_test(
  TARGET     test_ecbuild_bundle_shallow_update_fails
  TYPE       SCRIPT
  COMMAND    ${CMAKE_CURRENT_SOURCE_DIR}/run-test-invalid-update.sh
  ENVIRONMENT
    CMAKE_SOURCE_DIR=${CMAKE_SOURCE_DIR}
    CMAKE_CURRENT_SOURCE_DIR=${CMAKE_CURRENT_SOURCE_DIR}
    CMAKE_CURRENT_BINARY_DIR=${CMAKE_CURRENT_BINARY_DIR}
)

ecbuild_add_test(
  TARGET     test_ecbuild_bundle_shallow_noremote_fails
  TYPE       SCRIPT
  COMMAND    ${CMAKE_CURRENT_SOURCE_DIR}/run-test-invalid-noremote.sh
  ENVIRONMENT
    CMAKE_SOURCE_DIR=${CMAKE_SOURCE_DIR}
    CMAKE_CURRENT_SOURCE_DIR=${CMAKE_CURRENT_SOURCE_DIR}
    CMAKE_CURRENT_BINARY_DIR=${CMAKE_CURRENT_BINARY_DIR}
)
