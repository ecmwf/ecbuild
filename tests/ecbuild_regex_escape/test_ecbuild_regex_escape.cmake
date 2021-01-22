cmake_minimum_required( VERSION 3.6 FATAL_ERROR )

find_package( ecbuild REQUIRED )

ecbuild_add_c_flags( "-O2" )              # should be able to add to (nearly) all compilers
ecbuild_add_c_flags( "-fooxxx" NO_FAIL )  # should not add to any compiler

if( CMAKE_C_FLAGS MATCHES "-O2" )
  message("Flag -O2 added")
else()
  message(FATAL_ERROR "Failed to add C flag -O2" )
endif()

if( CMAKE_C_FLAGS MATCHES "-fooxxx" )
  message(FATAL_ERROR "Flag -fooxxx wrongly added" )
else()
  message("Successfully skiped addition of fake C flag -fooxxx")
endif()
