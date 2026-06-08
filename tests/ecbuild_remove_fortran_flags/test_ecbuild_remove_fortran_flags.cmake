
set(CMAKE_Fortran_COMPILER_LOADED TRUE)
set(CMAKE_BUILD_TYPE Testing)
set(CMAKE_Fortran_FLAGS_TESTING "unused")

include(ecbuild_log)
include(ecbuild_remove_fortran_flags)

function(test_remove_flags args input expected)
    set(CMAKE_Fortran_FLAGS "${input}")
    ecbuild_remove_fortran_flags(${args})
    if(NOT CMAKE_Fortran_FLAGS STREQUAL "${expected}")
        message(FATAL_ERROR
            "ecbuild_remove_fortran_flags(\"${args}\"): "
            "input \"${input}\", "
            "output \"${CMAKE_Fortran_FLAGS}\", "
            "expected \"${expected}\"")
    endif()
endfunction()

function(test_remove_project_flags args input input_build expected expected_build)
    set(CMAKE_BUILD_TYPE Testing)
    set(PNAME TEST)
    set(TEST_Fortran_FLAGS "${input}")
    set(TEST_Fortran_FLAGS_TESTING "${input_build}")
    ecbuild_remove_fortran_flags(${args} PROJECT)
    if(NOT TEST_Fortran_FLAGS STREQUAL "${expected}")
        message(FATAL_ERROR
            "ecbuild_remove_fortran_flags(\"${args} PROJECT\"): "
            "input \"${input}\", "
            "output \"${TEST_Fortran_FLAGS}\", "
            "expected \"${expected}\"")
    endif()
    if(NOT TEST_Fortran_FLAGS_TESTING STREQUAL "${expected_build}")
        message(FATAL_ERROR
            "ecbuild_remove_fortran_flags(\"${args} PROJECT\") build flags: "
            "input \"${input_build}\", "
            "output \"${TEST_Fortran_FLAGS_TESTING}\", "
            "expected \"${expected_build}\"")
    endif()
endfunction()

test_remove_flags("-g" "-g" "")
test_remove_flags("-g" " -g" " ")
test_remove_flags("-g" "-g " "")
test_remove_flags("-g" "-g -foo" "-foo")
test_remove_flags("-g" "-bar -g -baz" "-bar -baz")
test_remove_flags("-g" "-ggg -g -gcc -g" "-ggg -gcc ")
test_remove_flags("-g" "-gcc" "-gcc")
test_remove_flags("-g" "--g -g-" "--g -g-")
test_remove_flags("-g" "---g" "---g")
test_remove_flags("-g" "   -g" "   ")
test_remove_flags("-g" "-g   " "")
test_remove_flags("-g" "   -g   " "   ")
test_remove_flags("-g" "-g-g" "-g-g")

test_remove_flags("-foo;-bar" "-foobar" "-foobar")
test_remove_flags("-foo;-bar" "-barfoo" "-barfoo")
test_remove_flags("-foo;-bar" "-foo -bar" "")
test_remove_flags("-foo;-bar" "-foo -g -bar" "-g ")
test_remove_flags("-foo;-bar" "-g -bar -foo" "-g ")

set(CMAKE_BUILD_TYPE Unused)
test_remove_flags("-foo" "" "")
test_remove_flags("-foo;BUILD;Unused" "" "")

test_remove_project_flags("-g" "-g -foo" "unused -g" "-foo" "unused ")
test_remove_project_flags("-g;BUILD;TESTING" "-g -foo" "unused -g" "-g -foo" "unused ")

execute_process(
    COMMAND ${CMAKE_COMMAND}
            -DCMAKE_MODULE_PATH=${CMAKE_MODULE_PATH}
            -P ${CMAKE_CURRENT_LIST_DIR}/test_ecbuild_remove_fortran_flags_project_undefined.cmake
    RESULT_VARIABLE _project_undefined_result
    OUTPUT_VARIABLE _project_undefined_stdout
    ERROR_VARIABLE _project_undefined_stderr
)

if(NOT _project_undefined_result EQUAL 0)
    message(FATAL_ERROR
        "ecbuild_remove_fortran_flags(PROJECT ...) should succeed when TEST_Fortran_FLAGS is not defined:\n"
        "${_project_undefined_stdout}${_project_undefined_stderr}")
endif()
