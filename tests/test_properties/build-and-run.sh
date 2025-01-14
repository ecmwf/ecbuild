#!/usr/bin/env bash

set -e

HERE=${CMAKE_CURRENT_BINARY_DIR:-"$( cd $( dirname "${BASH_SOURCE[0]}" ) && pwd -P )"}
SOURCE=${CMAKE_CURRENT_SOURCE_DIR:-$HERE}

# Add ecbuild to path
export PATH=$SOURCE/../../bin:$PATH
echo $PATH
echo $SOURCE

# Build the project
ecbuild $SOURCE/test_project -B $HERE/build

# Run only one specific test (which should invoke the others)
ctest --test-dir $HERE/build -R write_world_after_hello

# Check if the output is as expected
echo -n "Hello, World!" | diff - $HERE/build/output.txt
