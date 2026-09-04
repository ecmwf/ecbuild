cmake_minimum_required( VERSION 3.18 FATAL_ERROR )

find_package( ecbuild REQUIRED )
project( test_mkl_fake_intel_cpu VERSION 0.1.0 LANGUAGES C )

# Enable the feature under test before FindMKL.cmake is loaded.
set( MKL_FAKE_INTEL_CPU ON )

find_package( MKL QUIET )

if( MKL_FOUND )

  message( STATUS "test_mkl_fake_intel_cpu: testing against real MKL (${MKL_LIB_CORE})" )

  # FindMKL has created the override object library and prepended its objects
  # to MKL_LIBRARIES. libm is explicit because this is a pure C link.
  ecbuild_add_test( TARGET      test_mkl_fake_intel_cpu
                    SOURCES     test_mkl_fake_intel_cpu.c
                    INCLUDES    ${MKL_INCLUDE_DIRS}
                    DEFINITIONS HAVE_MKL
                    LIBS        ${MKL_LIBRARIES} m )

else()

  message( STATUS "test_mkl_fake_intel_cpu: MKL not found, falling back to fake mkl_core" )

  add_library( fakemkl_core STATIC fake_mkl_core.c )
  add_library( mkl_fake_intel_cpu OBJECT mkl_fake_intel_cpu.c )
  set_target_properties( mkl_fake_intel_cpu PROPERTIES POSITION_INDEPENDENT_CODE ON )

  ecbuild_add_test( TARGET  test_mkl_fake_intel_cpu
                    SOURCES test_mkl_fake_intel_cpu.c
                    OBJECTS mkl_fake_intel_cpu
                    LIBS    fakemkl_core )

endif()