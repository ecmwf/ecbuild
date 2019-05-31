cmake_minimum_required(VERSION 3.6 FATAL_ERROR)
find_package( ecbuild 3.0.0 REQUIRED )
project( find_lapack VERSION 0.0.0 LANGUAGES CXX )

ecbuild_find_package( NAME MKL QUIET )
ecbuild_add_option( FEATURE MKL DEFAULT ON
                    CONDITION MKL_FOUND )
if( HAVE_MKL )
    set( LAPACK_FOUND 1 )
    set( LAPACK_LIBRARIES ${MKL_LIBRARIES} )
    ecbuild_info( "MKL is used for LAPACK through ecbuild's FindMKL.cmake" )
endif()

if( NOT LAPACK_FOUND )
    ecbuild_find_package( NAME LAPACK REQUIRED )
    if( TARGET lapack )
        ecbuild_info( "LAPACK is imported using CMake targets" )
        set( LAPACK_LIBRARIES lapack )
        if( TARGET blas )
            list( APPEND LAPACK_LIBRARIES blas )
            # linker bug ( ld version <= 2.27 ) requires blas to be added explicitly
            # This would not be required if lapack was to be linked in a library rather than executable
        endif()
    else()
        ecbuild_info( "LAPACK is imported through default CMake's FindLAPACK.cmake" )
    endif()
endif()

ecbuild_info( "LAPACK_LIBRARIES : ${LAPACK_LIBRARIES}" )

### Try to link executable with LAPACK_LIBRARIES

ecbuild_add_test( TARGET  test_dgemm 
                  SOURCES test_dgemm.cc
                  LIBS    ${LAPACK_LIBRARIES} )
