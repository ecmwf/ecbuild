cmake_minimum_required( VERSION 3.18 FATAL_ERROR )

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

set(_cmake_c_flags_before_project "${CMAKE_C_FLAGS}")
set(TESTFLAGS_C_FLAGS "-developer_owned")
set(TESTFLAGS_C_FLAGS_RELEASE "-developer_owned_release")
ecbuild_add_c_flags( "-O2" PROJECT )
ecbuild_add_c_flags( "-O1" BUILD RELEASE PROJECT )

message("CMAKE_C_FLAGS ${CMAKE_C_FLAGS}")
message("CMAKE_CXX_FLAGS ${CMAKE_CXX_FLAGS}")
message("TESTFLAGS_C_FLAGS ${TESTFLAGS_C_FLAGS}")
message("TESTFLAGS_C_FLAGS_RELEASE ${TESTFLAGS_C_FLAGS_RELEASE}")

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
  message("Successfully skipped addition of fake C flag -fooxxx")
endif()

if( CMAKE_CXX_FLAGS MATCHES "-O1" )
  message("Flag -O1 added")
else()
  message(FATAL_ERROR "Failed to add CXX flag -O1" )
endif()

if( CMAKE_CXX_FLAGS MATCHES "-fantasyflag" )
  message(FATAL_ERROR "Flag -fantasyflag wrongly added" )
else()
  message("Successfully skipped addition of fake CXX flag -fantasyflag")
endif()

if( TESTFLAGS_C_FLAGS MATCHES "-developer_owned" AND TESTFLAGS_C_FLAGS MATCHES "-O2" )
  message("Project C flag -O2 added")
else()
  message(FATAL_ERROR "Failed to add project C flag -O2" )
endif()

if( TESTFLAGS_C_FLAGS_RELEASE MATCHES "-developer_owned_release" AND TESTFLAGS_C_FLAGS_RELEASE MATCHES "-O1" )
  message("Project C flag -O1 added to RELEASE")
else()
  message(FATAL_ERROR "Failed to add project C flag -O1 to RELEASE" )
endif()

if( NOT CMAKE_C_FLAGS STREQUAL "${_cmake_c_flags_before_project}" )
  message(FATAL_ERROR "CMAKE_C_FLAGS should not change when PROJECT is used" )
endif()

set(_project_undefined_source_dir ${CMAKE_CURRENT_BINARY_DIR}/project_undefined_src)
set(_project_undefined_binary_dir ${CMAKE_CURRENT_BINARY_DIR}/project_undefined_build)
file(MAKE_DIRECTORY ${_project_undefined_source_dir})
file(WRITE ${_project_undefined_source_dir}/CMakeLists.txt [=[
cmake_minimum_required( VERSION 3.18 FATAL_ERROR )

find_package( ecbuild 3.6 REQUIRED )

project(TestFlags VERSION 1.0 LANGUAGES C)

include( ecbuild_add_c_flags )
ecbuild_add_c_flags( "-O2" PROJECT )
ecbuild_add_c_flags( "-O1" BUILD RELEASE PROJECT )

if( NOT TESTFLAGS_C_FLAGS MATCHES "-O2" )
  message(FATAL_ERROR "Failed to add project C flag -O2 when TESTFLAGS_C_FLAGS was initially undefined" )
endif()

if( NOT TESTFLAGS_C_FLAGS_RELEASE MATCHES "-O1" )
  message(FATAL_ERROR "Failed to add project C flag -O1 to RELEASE when TESTFLAGS_C_FLAGS was initially undefined" )
endif()
]=])

execute_process(
  COMMAND ${CMAKE_COMMAND}
          -DCMAKE_MODULE_PATH=${CMAKE_MODULE_PATH}
          -Decbuild_DIR=${ecbuild_DIR}
          -S ${_project_undefined_source_dir}
          -B ${_project_undefined_binary_dir}
  RESULT_VARIABLE _project_undefined_result
  OUTPUT_VARIABLE _project_undefined_stdout
  ERROR_VARIABLE _project_undefined_stderr
)

if( NOT _project_undefined_result EQUAL 0 )
  message(FATAL_ERROR
    "ecbuild_add_c_flags(PROJECT ...) should succeed when TESTFLAGS_C_FLAGS is not defined:\n"
    "${_project_undefined_stdout}${_project_undefined_stderr}")
endif()
