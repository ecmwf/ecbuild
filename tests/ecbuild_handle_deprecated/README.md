# Handle CMAKE_*_DEPRECATED

Since CMake 4.4, and according to the CMake policy CMP0218, the non-cached variables
CMAKE_WARN_DEPRECATED and CMAKE_ERROR_DEPRECATED are essentially ignored. Instead, the
new policy uses cmake_diagnostic/CMD_DEPRECATED to control the behaviour of deprecated
features. From CMake 4.4 onwards, if any of the CMAKE_*_DEPRECATED variables are set
while CMP0218 is unset, CMake issues a policy warning.

This example configures a project that uses ecbuild, and ensures that no policy warning
is issued during the configuration phase. A second project ensures that project code
still issue policy warning.

## Usage

The test is normally run through CTest:

    ctest -R test_ecbuild_handle_deprecated

It can also be run directly, in which case the project is configured in a temporary
directory that is removed on exit:

    ./build.sh
