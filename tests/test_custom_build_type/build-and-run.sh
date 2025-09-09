#!/usr/bin/env bash

set -e
set -x

HERE=${CMAKE_CURRENT_BINARY_DIR:-"$( cd $( dirname "${BASH_SOURCE[0]}" ) && pwd -P )"}
SOURCE=${CMAKE_CURRENT_SOURCE_DIR:-$HERE}

# Add ecbuild to path
export PATH=$SOURCE/../../bin:$PATH
echo $PATH
echo $SOURCE

function assert_flag() {
  local file=$1
  local variable=$2
  local flag=$3
  local found=$(grep "${variable} = " ${file} | grep "\\${flag}" | wc -l)

  if [ $found -ne 1 ]; then
      echo "File ${file} does not contain exacly one of '$3'"
      exit 1
  fi
}

# 1) Build the project -- using toolchain

mkdir -p $HERE/build-1
cd $HERE/build-1
cmake $SOURCE/test_project \
  -DCMAKE_BUILD_TYPE=CUSTOM \
  -DCMAKE_TOOLCHAIN_FILE=$SOURCE/toolchain.cmake

# Check that the flags are correctly set for Fortran, C and C++

assert_flag CMakeFiles/proj_f.dir/flags.make "Fortran_FLAGS" "-Wno-common-f-flag"
assert_flag CMakeFiles/proj_f.dir/flags.make "Fortran_FLAGS" "-Wno-custom-f-flag"

assert_flag CMakeFiles/proj_c.dir/flags.make "C_FLAGS" "-Wno-common-c-flag"
assert_flag CMakeFiles/proj_c.dir/flags.make "C_FLAGS" "-Wno-custom-c-flag"

assert_flag CMakeFiles/proj_cxx.dir/flags.make "CXX_FLAGS" "-Wno-common-cxx-flag"
assert_flag CMakeFiles/proj_cxx.dir/flags.make "CXX_FLAGS" "-Wno-custom-cxx-flag"

# 2) Build the project -- using explicit ECBUILD_*_FLAGS_<type> variables

mkdir -p $HERE/build-2
cd $HERE/build-2
cmake $SOURCE/test_project \
  -DCMAKE_BUILD_TYPE=CUSTOM \
  -DECBUILD_Fortran_FLAGS="-Wno-common-f-flag" \
  -DECBUILD_C_FLAGS="-Wno-common-c-flag" \
  -DECBUILD_CXX_FLAGS="-Wno-common-cxx-flag" \
  -DECBUILD_Fortran_FLAGS_CUSTOM="-Wno-custom-f-flag" \
  -DECBUILD_C_FLAGS_CUSTOM="-Wno-custom-c-flag" \
  -DECBUILD_CXX_FLAGS_CUSTOM="-Wno-custom-cxx-flag"

# Check that the flags are correctly set for Fortran, C and C++

assert_flag CMakeFiles/proj_f.dir/flags.make "Fortran_FLAGS" "-Wno-common-f-flag"
assert_flag CMakeFiles/proj_f.dir/flags.make "Fortran_FLAGS" "-Wno-custom-f-flag"

assert_flag CMakeFiles/proj_c.dir/flags.make "C_FLAGS" "-Wno-common-c-flag"
assert_flag CMakeFiles/proj_c.dir/flags.make "C_FLAGS" "-Wno-custom-c-flag"

assert_flag CMakeFiles/proj_cxx.dir/flags.make "CXX_FLAGS" "-Wno-common-cxx-flag"
assert_flag CMakeFiles/proj_cxx.dir/flags.make "CXX_FLAGS" "-Wno-custom-cxx-flag"
