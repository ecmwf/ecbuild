# Regression test for the MKL_FAKE_INTEL_CPU option added to FindMKL.cmake.
#
# Uses the FindMKL module itself: when a real Intel MKL is available (e.g.
# after `module load intel-mkl/2025.3.1`, which sets MKLROOT), the test links
# against the real MKL libraries, exactly as a downstream project would, with
# the mkl_serv_intel_cpu_true() override object that FindMKL prepends to
# MKL_LIBRARIES when MKL_FAKE_INTEL_CPU is ON. The test also calls
# MKL_Get_Version() so that real MKL code is genuinely exercised.
#
# When MKL is not available, it falls back to a stand-in for mkl_core that
# reproduces the same link situation: a static library defining
# mkl_serv_intel_cpu_true() returning false (as mkl_core does on non-Intel
# CPUs), overridden by an object linked *before* it so its definition wins.

# Enable the feature under test before FindMKL.cmake is loaded
set( MKL_FAKE_INTEL_CPU ON )

find_package( MKL QUIET )

if( MKL_FOUND )

  message( STATUS "test_mkl_fake_intel_cpu: testing against real MKL (${MKL_LIB_CORE})" )

  # FindMKL has created the 'mkl_fake_intel_cpu' override object library and
  # prepended its objects to MKL_LIBRARIES; consume MKL_LIBRARIES as-is.
  # Note: 'm' is appended because the MKL shared libraries are underlinked
  # (no DT_NEEDED on libm) and this is a pure C link -- C++/Fortran drivers
  # would pull in libm implicitly.
  ecbuild_add_test( TARGET      test_mkl_fake_intel_cpu
                    SOURCES     test_mkl_fake_intel_cpu.c
                    INCLUDES    ${MKL_INCLUDE_DIRS}
                    DEFINITIONS HAVE_MKL
                    LIBS        ${MKL_LIBRARIES} m )

else()

  message( STATUS "test_mkl_fake_intel_cpu: MKL not found, falling back to fake mkl_core" )

  # 1. Stand-in for mkl_core
  # Note: plain add_library() is used here on purpose, not ecbuild_add_library().
  # ecbuild_add_library() registers the target in ${PROJECT_NAME}_ALL_LIBS even
  # with NOINSTALL, which would make ecbuild_install_project() try to install an
  # 'ecbuild-targets' export set containing no targets -- breaking configure.
  add_library( fakemkl_core STATIC fake_mkl_core.c )

  # 2. The override object: same definition as the one FindMKL.cmake
  #    generates when MKL_FAKE_INTEL_CPU is ON.
  add_library( mkl_fake_intel_cpu OBJECT mkl_fake_intel_cpu.c )

  set_target_properties( mkl_fake_intel_cpu PROPERTIES POSITION_INDEPENDENT_CODE ON )

  # 3. Test executable: the override object is always included (it's not an
  #    archive), so mkl_serv_intel_cpu_true() is already resolved by the time
  #    the linker reaches fakemkl_core -- its definition is never extracted
  #    from the archive.
  ecbuild_add_test( TARGET  test_mkl_fake_intel_cpu
                    SOURCES test_mkl_fake_intel_cpu.c
                    OBJECTS mkl_fake_intel_cpu
                    LIBS    fakemkl_core )

endif()
