# Regression test for the MKL_FAKE_INTEL_CPU option added to FindMKL.cmake.
#
# Does not require a real MKL installation. It reproduces the exact
# situation FindMKL.cmake addresses: a library ("fakemkl_core") defining
# mkl_serv_intel_cpu_true() returning false (as mkl_core.a does on
# non-Intel CPUs), and an object file providing an overriding definition
# that must be linked *before* that library so its definition wins.

# 1. Stand-in for mkl_core
# Note: plain add_library() is used here on purpose, not ecbuild_add_library().
# ecbuild_add_library() registers the target in ${PROJECT_NAME}_ALL_LIBS even
# with NOINSTALL, which would make ecbuild_install_project() try to install an
# 'ecbuild-targets' export set containing no targets -- breaking configure.
add_library( fakemkl_core STATIC fake_mkl_core.c )

# 2. The override object, built the same way FindMKL.cmake builds it when
#    MKL_FAKE_INTEL_CPU is ON.
set( _mkl_fake_intel_cpu_src "${CMAKE_CURRENT_BINARY_DIR}/mkl_fake_intel_cpu.c" )
file( WRITE ${_mkl_fake_intel_cpu_src}
"/* Auto-generated: mirrors FindMKL.cmake MKL_FAKE_INTEL_CPU */
int mkl_serv_intel_cpu_true(void) { return 1; }
" )

add_library( mkl_fake_intel_cpu OBJECT ${_mkl_fake_intel_cpu_src} )

set_target_properties( mkl_fake_intel_cpu PROPERTIES POSITION_INDEPENDENT_CODE ON )

# 3. Test executable: the override object is always included (it's not an
#    archive), so mkl_serv_intel_cpu_true() is already resolved by the time
#    the linker reaches fakemkl_core -- its definition is never extracted
#    from the archive.
ecbuild_add_test( TARGET  test_mkl_fake_intel_cpu
                   SOURCES test_mkl_fake_intel_cpu.c
                   OBJECTS mkl_fake_intel_cpu
                   LIBS    fakemkl_core )
