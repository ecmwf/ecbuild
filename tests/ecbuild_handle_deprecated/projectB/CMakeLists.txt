cmake_minimum_required( VERSION 3.18 FATAL_ERROR )

find_package( ecbuild REQUIRED )
project( projectB VERSION 0.0.1 LANGUAGES CXX )

# This project performs no build actions.

# Since CMake 4.4+, per CMP0218, setting either of the CMAKE_{WARN,ERROR}_DEPRECATED
# non-cached variables produces a deprecation message.
#
# Although the deprecation messages in `ecbuild` itself are suppressed, any use
# of these variables in project CMake code will trigger the deprecation messages.

set( CMAKE_WARN_DEPRECATED ON )
