#!/usr/bin/env bash

set -e

HERE=${CMAKE_CURRENT_BINARY_DIR:-"$( cd $( dirname "${BASH_SOURCE[0]}" ) && pwd -P )"}
SOURCE=${CMAKE_CURRENT_SOURCE_DIR:-$HERE}

# Add ecbuild to path
export PATH=$SOURCE/../../bin:$PATH
echo $PATH
echo $SOURCE

check_lib_exists() {

  local libname=$1
  local ext=$2

  if [ ! -f $HERE/build/lib/lib${libname}.$ext ]; then
     echo "$HERE/build/lib/lib${libname}.$ext not found"
     exit 1 
  fi

}

dyn_ext="so"
if [[ $(uname) == "Darwin" ]]; then
  dyn_ext="dylib"
fi
static_ext="a"

# enable shared libraries across project
$SOURCE/clean.sh
ecbuild -DENABLE_TESTS=OFF -DBUILD_SHARED_LIBS=OFF $SOURCE/test_project -B $HERE/build
cmake --build build
check_lib_exists test_shared_libs ${static_ext}
check_lib_exists lib2 ${static_ext}
check_lib_exists lib1 ${dyn_ext}

# enable target specific override 1
$SOURCE/clean.sh
ecbuild -DENABLE_TESTS=OFF -DECBUILD_TARGET_test_shared_libs_TYPE=SHARED -DBUILD_SHARED_LIBS=OFF $SOURCE/test_project -B $HERE/build
cmake --build build
check_lib_exists test_shared_libs ${dyn_ext}
check_lib_exists lib2 ${static_ext}
check_lib_exists lib1 ${dyn_ext}

# enable target specific override 2
$SOURCE/clean.sh
ecbuild -DENABLE_TESTS=OFF -DECBUILD_TARGET_test_shared_libs_TYPE=STATIC $SOURCE/test_project -B $HERE/build
cmake --build build
check_lib_exists test_shared_libs ${static_ext}
check_lib_exists lib2 ${dyn_ext}
check_lib_exists lib1 ${dyn_ext}
