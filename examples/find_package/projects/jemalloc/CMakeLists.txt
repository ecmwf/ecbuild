cmake_minimum_required( VERSION 3.18 FATAL_ERROR )

find_package( ecbuild 3.0.0 REQUIRED )
project( find_jecmalloc VERSION 0.0.0 LANGUAGES C Fortran )

ecbuild_add_option( FEATURE JEMALLOC
                    DEFAULT OFF
                    DESCRIPTION "jemalloc memory handling"
                    REQUIRED_PACKAGES Jemalloc )
if( HAVE_JEMALLOC )
  # Automatically link all executables with tcmalloc
  set( CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -Wl,-rpath,${JEMALLOC_LIBRARY_DIR}" )
  set( CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} ${JEMALLOC_LIBRARIES}" )
endif()

ecbuild_add_executable( TARGET main SOURCES main.c )
ecbuild_add_executable( TARGET main_f SOURCES main.F90 )

# Run executables as test
ecbuild_add_test( TARGET test_main   COMMAND main   )
ecbuild_add_test( TARGET test_main_f COMMAND main_f )
