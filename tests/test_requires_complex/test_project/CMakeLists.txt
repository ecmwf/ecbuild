cmake_minimum_required(VERSION 3.7 FATAL_ERROR)

find_package( ecbuild REQUIRED )
project( test_test_requires_complex VERSION 0.1.0 LANGUAGES NONE )

ecbuild_add_test(
    TARGET clean_output
    COMMAND ${CMAKE_COMMAND}
    ARGS -E remove ${CMAKE_CURRENT_BINARY_DIR}/hello.txt ${CMAKE_CURRENT_BINARY_DIR}/world.txt ${CMAKE_CURRENT_BINARY_DIR}/helloworld.txt
)

ecbuild_add_test(
    TARGET write_hello
    TEST_REQUIRES clean_output
    COMMAND bash
    ARGS -c "echo -n 'Hello, ' >> ${CMAKE_CURRENT_BINARY_DIR}/hello.txt"
)

ecbuild_add_test(
    TARGET write_world
    TEST_REQUIRES clean_output
    COMMAND bash
    ARGS -c "echo -n 'World!' >> ${CMAKE_CURRENT_BINARY_DIR}/world.txt"
)

ecbuild_add_test(
    TARGET combine_hello_world
    TEST_REQUIRES write_hello write_world
    COMMAND bash
    ARGS -c "cat ${CMAKE_CURRENT_BINARY_DIR}/hello.txt ${CMAKE_CURRENT_BINARY_DIR}/world.txt >> ${CMAKE_CURRENT_BINARY_DIR}/helloworld.txt"
)
