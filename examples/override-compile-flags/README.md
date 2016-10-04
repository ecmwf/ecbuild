An example of a bundle containing two sub-projects, bar and foo, where foo
needs to override compile flags of several source files.

# Setup

    SRC_DIR=$(pwd)
    BUILD_DIR=$(pwd)/build
    mkdir -p ${BUILD_DIR} && cd ${BUILD_DIR}

# Standard build using preset compile flags:

    ecbuild --build=Debug ${SRC_DIR}
    make VERBOSE=1

# Use custom compile flags defined in JSON data file:

    ecbuild --build=Debug -DFOO_ECBUILD_SOURCE_FLAGS=${SRC_DIR}/foo/flags-cray-debug.json ${SRC_DIR}
    make VERBOSE=1

    module switch cdt cdt/15.11
    ecbuild --build=Debug -DFOO_ECBUILD_SOURCE_FLAGS=${SRC_DIR}/foo/flags-cray-8.4.1-debug.json ${SRC_DIR}
    make VERBOSE=1

# Use custom compile flags defined in CMake script:

    ecbuild --build=Debug -DFOO_ECBUILD_COMPILE_FLAGS=${SRC_DIR}/foo/flags.cmake ${SRC_DIR}
    make VERBOSE=1
