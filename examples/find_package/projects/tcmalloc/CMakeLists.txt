cmake_minimum_required(VERSION 3.12 FATAL_ERROR)
find_package( ecbuild 3.0.0 REQUIRED )
project( find_tcmalloc VERSION 0.0.0 LANGUAGES C Fortran )

ecbuild_add_option( FEATURE TCMALLOC
                    DEFAULT OFF
                    DESCRIPTION "tcmalloc memory handling"
                    REQUIRED_PACKAGES Tcmalloc )
if( HAVE_TCMALLOC )
  # Automatically link all executables with tcmalloc
  set( CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -Wl,-rpath,${TCMALLOC_LIBRARY_DIR}" )
  set( CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} ${TCMALLOC_LIBRARIES}" )
endif()

ecbuild_add_executable( TARGET main SOURCES main.c )
ecbuild_add_executable( TARGET main_f SOURCES main.F90 )

# Run executables as test
ecbuild_add_test( TARGET test_main   COMMAND main   )
ecbuild_add_test( TARGET test_main_f COMMAND main_f )
