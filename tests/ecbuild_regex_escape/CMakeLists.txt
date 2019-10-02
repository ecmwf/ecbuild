
ecbuild_add_test(
  TARGET     test_ecbuild_regex_escape
  TYPE       SCRIPT
  COMMAND    ${CMAKE_COMMAND}
  ARGS       -DCMAKE_MODULE_PATH=${ECBUILD_MACROS_DIR}
             -P ${CMAKE_CURRENT_SOURCE_DIR}/test_ecbuild_regex_escape.cmake
)
