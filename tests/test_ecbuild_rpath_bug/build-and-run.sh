#!/usr/bin/env bash

set -e

HERE=${CMAKE_CURRENT_BINARY_DIR:-"$( cd $( dirname "${BASH_SOURCE[0]}" ) && pwd -P )"}
SOURCE=${CMAKE_CURRENT_SOURCE_DIR:-$HERE}

export PATH=$SOURCE/../../bin:$PATH

rm -rf $HERE/build
ecbuild $SOURCE/test_project -B $HERE/build
cmake --build $HERE/build --parallel ${CPU_COUNT:-2}
(cd $HERE/build; ctest --output-on-failure)