set(CMAKE_Fortran_COMPILER_LOADED TRUE)
set(CMAKE_BUILD_TYPE Testing)
set(PNAME TEST)
set(TEST_Fortran_FLAGS_TESTING "unused -g")

include(ecbuild_log)
include(ecbuild_remove_fortran_flags)

ecbuild_remove_fortran_flags(-g PROJECT)

if(DEFINED TEST_Fortran_FLAGS)
  message(FATAL_ERROR "TEST_Fortran_FLAGS should remain undefined when removing project flags from an undefined base variable")
endif()

if(NOT TEST_Fortran_FLAGS_TESTING STREQUAL "unused ")
  message(FATAL_ERROR "TEST_Fortran_FLAGS_TESTING should still be updated when TEST_Fortran_FLAGS is undefined")
endif()
