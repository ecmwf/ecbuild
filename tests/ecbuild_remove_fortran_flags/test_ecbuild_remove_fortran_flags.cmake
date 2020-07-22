
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
