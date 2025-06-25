cmake_minimum_required( VERSION 3.18 FATAL_ERROR )

find_package( ecbuild REQUIRED )
project( test_test_properties VERSION 0.1.0 LANGUAGES NONE )

ecbuild_add_test(
    TARGET clean_output
    TEST_PROPERTIES FIXTURES_SETUP clean_output
    COMMAND ${CMAKE_COMMAND}
    ARGS -E remove ${CMAKE_CURRENT_BINARY_DIR}/output.txt
)

ecbuild_add_test(
    TARGET write_hello
    TEST_PROPERTIES FIXTURES_SETUP write_hello FIXTURES_REQUIRED clean_output
    COMMAND bash
    ARGS -c "echo -n 'Hello, ' >> ${CMAKE_CURRENT_BINARY_DIR}/output.txt"
)

ecbuild_add_test(
    TARGET write_world_after_hello
    TEST_PROPERTIES FIXTURES_REQUIRED write_hello
    COMMAND bash
    ARGS -c "echo -n 'World!' >> ${CMAKE_CURRENT_BINARY_DIR}/output.txt"
)
