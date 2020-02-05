cmake_minimum_required(VERSION 3.9 FATAL_ERROR)
find_package( ecbuild 3.3.0 REQUIRED )
project( find_cuda  VERSION 0.0.0 LANGUAGES CXX )

macro( enable_cuda )

    include(CheckLanguage)
    check_language(CUDA)

    if( CMAKE_CUDA_COMPILER )
        enable_language( CUDA )
        ecbuild_info( "CUDA language enabled" )

        find_package( CUDAToolkit QUIET )

        # Backward compatibility for CMake version < 3.17
        if( NOT TARGET CUDA::cudart )
            # There is no find_package(CUDART) in CMake. So we need to do that manually.
            # https://gitlab.kitware.com/cmake/cmake/issues/17816
            find_library(CUDA_CUDART_LIBRARY cudart ${CMAKE_CUDA_IMPLICIT_LINK_DIRECTORIES})
            mark_as_advanced(CUDA_CUDART_LIBRARY)
            if (NOT CUDA_CUDART_LIBRARY)
                message(FATAL_ERROR "Cuda runtime was not found")
            endif()
            add_library( CUDA::cudart INTERFACE IMPORTED )
            set_target_properties(CUDA::cudart PROPERTIES
                  INTERFACE_INCLUDE_DIRECTORIES ${CMAKE_CUDA_TOOLKIT_INCLUDE_DIRECTORIES}
                  INTERFACE_LINK_LIBRARIES ${CUDA_CUDART_LIBRARY}
            )
        endif()
        if( NOT TARGET CUDA::cudart_static )
            # There is no find_package(CUDART) in CMake. So we need to do that manually.
            # https://gitlab.kitware.com/cmake/cmake/issues/17816
            find_library(CUDA_CUDART_STATIC_LIBRARY cudart_static ${CMAKE_CUDA_IMPLICIT_LINK_DIRECTORIES})
            mark_as_advanced(CUDA_CUDART_STATIC_LIBRARY)
            if (NOT CUDA_CUDART_STATIC_LIBRARY)
                message(FATAL_ERROR "Cuda runtime was not found")
            endif()
            add_library( CUDA::cudart_static INTERFACE IMPORTED )
            set_target_properties(CUDA::cudart_static PROPERTIES
                  INTERFACE_INCLUDE_DIRECTORIES ${CMAKE_CUDA_TOOLKIT_INCLUDE_DIRECTORIES}
                  INTERFACE_LINK_LIBRARIES ${CUDA_CUDART_STATIC_LIBRARY}
            )
        endif()

    else()
      ecbuild_critical("CUDA enabled through find_package(CUDA) instead of enable_language(CUDA)")
      find_package( CUDA )
    endif()
endmacro()

enable_cuda()

ecbuild_add_library(
    TYPE SHARED
    TARGET  add 
    SOURCES add.h add.cu kernel_add.h kernel_add.cu
    PUBLIC_LIBS CUDA::cudart
)


ecbuild_add_executable(
    TARGET  main 
    SOURCES main.cc
    LIBS    add
)

