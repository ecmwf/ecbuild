#!/usr/bin/env bash

set -e
set -x

HERE=${CMAKE_CURRENT_BINARY_DIR:-"$( cd $( dirname "${BASH_SOURCE[0]}" ) && pwd -P )"}
SOURCE=${CMAKE_CURRENT_SOURCE_DIR:-$HERE}

# Add ecbuild to path
export PATH=$SOURCE/../../bin:$PATH
echo $PATH
echo $SOURCE

# Build the project
mkdir -p $HERE/build
cd $HERE/build
cmake $SOURCE/test_project -DCMAKE_BUILD_TYPE=CUSTOM -DCMAKE_TOOLCHAIN_FILE=$SOURCE/toolchain.cmake

flags=$(grep Fortran_FLAGS CMakeFiles/proj.dir/flags.make | grep '\-common-flag -custom-flag' | wc -l)

if [ $flags -ne 1 ]
then
  exit 1
fi

