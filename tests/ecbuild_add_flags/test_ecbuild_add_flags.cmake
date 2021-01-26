cmake_minimum_required( VERSION 3.12 FATAL_ERROR )

find_package( ecbuild 3.6 REQUIRED )

project(TestFlags VERSION 1.0 LANGUAGES C CXX )

include(CheckCCompilerFlag)
include( ecbuild_add_c_flags )

ecbuild_add_c_flags( "-O2" )               # should be able to add to (nearly) all compilers
ecbuild_add_c_flags( "-g -O1" )            # should be able to add to (nearly) all compilers
ecbuild_add_c_flags( "-O1" BUILD RELEASE)  # should be able to add to (nearly) all compilers
ecbuild_add_c_flags( "-g -O1" BUILD DEBUG) # should be able to add to (nearly) all compilers
ecbuild_add_c_flags( "-fooxxx" NO_FAIL )   # should not add to any compiler

ecbuild_add_cxx_flags( "-O1" )              # should be able to add to (nearly) all compilers
ecbuild_add_cxx_flags( "-barxxx" NO_FAIL )  # should not add to any compiler

message("CMAKE_C_FLAGS ${CMAKE_C_FLAGS}")
message("CMAKE_CXX_FLAGS ${CMAKE_CXX_FLAGS}")

if( CMAKE_C_FLAGS MATCHES "-O2" )
  message("Flag -O2 added")
else()
  message(FATAL_ERROR "Failed to add C flag -O2" )
endif()

if( CMAKE_C_FLAGS MATCHES "-g -O1" )
  message("Flag -g -O1 added")
else()
  message(FATAL_ERROR "Failed to add C flag -g -O1" )
endif()

if( CMAKE_C_FLAGS_RELEASE MATCHES "-O1" )
  message("Flag -O1 added")
else()
  message(FATAL_ERROR "Failed to add C flag -O1 to RELEASE" )
endif()

if( CMAKE_C_FLAGS_DEBUG MATCHES "-g -O1" )
  message("Flag -g -O1 added")
else()
  message(FATAL_ERROR "Failed to add C flag -g -O1 to DEBUG" )
endif()

if( CMAKE_C_FLAGS MATCHES "-fooxxx" )
  message(FATAL_ERROR "Flag -fooxxx wrongly added" )
else()
  message("Successfully skiped addition of fake C flag -fooxxx")
endif()

if( CMAKE_CXX_FLAGS MATCHES "-O1" )
  message("Flag -O1 added")
else()
  message(FATAL_ERROR "Failed to add CXX flag -O1" )
endif()

if( CMAKE_CXX_FLAGS MATCHES "-barxxx" )
  message(FATAL_ERROR "Flag -barxxx wrongly added" )
else()
  message("Successfully skiped addition of fake CXX flag -barxxx")
endif()
