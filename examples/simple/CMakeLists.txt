# CMake 3.11 is a minimal requirement for ecBuild. However, we strongly
# recommend using CMake 3.12 or higher
cmake_minimum_required( VERSION 3.11 FATAL_ERROR )

# If you plan on using cmake directly (rather than the `ecbuild` wrapper
# script), make sure that ecBuild can be found, by doing at least one of these:
# * Add ecBuild's `cmake` directory (`share/ecbuild/cmake` when installed) to `CMAKE_MODULE PATH`
# * (CMake 3.12 or higher) Set `ecbuild_ROOT` to the ecBuild install directory
# * Set `ecbuild_DIR` to ecBuild's `lib/cmake/ecbuild` directory
# * Add ecBuild's `cmake` directory to `CMAKE_PREFIX_PATH`
find_package(ecbuild REQUIRED)

# The `project` macro is overridden by ecBuild, which is why
# `find_package(ecbuild)` has to be done before `project()`
project( simple VERSION 0.10.0 LANGUAGES C CXX Fortran )

# Declaring options
# =================
#
# `ecbuild_add_option` is an enhanced version of CMake's `add_option`.
#
# In this case, the `MATRIX` feature can be requested with the `ENABLE_MATRIX`
# CMake variable. Unless `DEFAULT OFF` is specified, the option is on by
# default (provided its `CONDITION` is empty or satisfied).
#
# From your CMake scripts, you can then query the feature using the
# `HAVE_MATRIX` variable.
#
# Any option declared gets automatically advertised when the package is
# installed, enabling the use of e.g. `find_package(simple COMPONENTS MATRIX)`.
# It can also be queried via the `simple_MATRIX_FOUND` variable if the
# component is optional.
#
# The `REQUIRED_PACKAGES` option is a convenience for options that depend on
# certain packages being available. For each package, it expects a string that
# represents a valid argument list for `ecbuild_find_package`. This behaves as
# follows:
# * If `LAPACK` is found, the option will be enabled, unless the
#  `ENABLE_MATRIX` variable is set to `OFF`.
# * If `LAPACK` cannot be found, the behaviour depends on the value of
#   `ENABLE_MATRIX`:
#   * If `ON`, ecBuild will abort with a critical error
#   * If `OFF` or not set, the feature will be disabled
ecbuild_add_option( FEATURE MATRIX
                    DESCRIPTION "Use matrix operations"
                    REQUIRED_PACKAGES "NAME LAPACK" )

# For more complex requirements, the `CONDITION` argument can be any expression
# acceptable in an `if` statement. The same behaviour can also be achieved using
# `CONDITION HAVE_MATRIX` together with `REQUIRED_PACKAGES "NAME GSL"`
find_package(GSL QUIET)
ecbuild_add_option( FEATURE BESSEL
                    DESCRIPTION "Compute Bessel function"
                    CONDITION HAVE_MATRIX AND GSL_FOUND )

# Declaring targets
# =================
#
# ecBuild provides wrappers around CMake's `add_library`, `add_executable`, and
# `add_test`. They take care of the target's creation, as well as making sure
# it gets installed and exported properly. They also provide a concise way of
# adding library dependencies and declaring include directories.
#
# Libraries
# ---------
#
# In `circle/CMakeLists.txt`, the library `circle` is created as a shared
# library (the default), and has only one source file `area.f90`.
#
# ecbuild_add_library(
#     TARGET circle
#     TYPE SHARED
#     SOURCES area.f90
# )
#
# If some header files are present in the list of source files, they can be
# automatically installed by specifying `INSTALL_HEADERS LISTED`. If the
# library has some dependencies, they can be declared with `PUBLIC_LIBS lib1
# [lib2...]` and/or `PRIVATE_LIBS lib1 [lib2...]`, where `PUBLIC` and `PRIVATE`
# have the same meaning as for CMake's `target_link_libraries`. The same
# applies for include directories using the `PUBLIC_INCLUDES` and
# `PRIVATE_INCLUDES` keywords.
#
# Tests
# -----
#
# A test can be defined in the same way. Since the distinction between public
# and private dependencies has less importance for tests and executable, they
# can be provided using the `LIBS` and `INCLUDES` keywords.
#
# ecbuild_add_test(
#     TARGET  test_area
#     SOURCES test_area.c
#     LIBS    circle
# )
#
# Some tests may need to run a script rather than an executable target. This
# can be done as well, replacing the `TARGET` keyword by `COMMAND` (and removing
# `SOURCES` and `LIBS`), pointing to a script file to be run. Additional
# arguments can be provided with the `ARGS` keyword, and environment variables
# using the `ENVIRONMENT` keyword.
#
# Since tests may depend on some features being enabled, the `CONDITION`
# keyword can be used, just like in `ecbuild_add_option`.
#
# Executables
# -----------
#
# The same semantics apply for executables. In `compute/CMakeLists.txt`, the
# `compute` executable is made from the source file `compute.cc` with
# additional preprocessor definitions fetched from `${compute_defs}`, and with
# a dependency on the `circle` library.
#
# ecbuild_add_executable(
#
#     TARGET
#         compute
#
#     SOURCES
#         compute.cc
#
#     DEFINITIONS
#         "${compute_defs}"
#
#     LIBS
#         circle
# )

add_subdirectory( circle )

add_subdirectory( compute )

# Generating pkg-config files
# ===========================
#
# A pkg-config file will be created for the `circle` library. It will be
# installed in `lib/pkgconfig/circle.pc`.
ecbuild_pkgconfig(
    NAME circle
    DESCRIPTION "Functions on circles"
    LIBRARIES circle )

# Epilogue
# ========
#
# This will ensure everything gets installed in a unified way, provide
# appropriate install locations, and generate a `<project>-config.cmake`
# allowing the package to be imported from other CMake projects.
ecbuild_install_project( NAME ${PROJECT_NAME} )

# This will print a summary of the build environment and options to the screen
# when configuration is done.
ecbuild_print_summary()
