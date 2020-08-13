#!/usr/bin/env bash

set -e

HERE=${CMAKE_CURRENT_BINARY_DIR:-"$( cd $( dirname "${BASH_SOURCE[0]}" ) && pwd -P )"}
SOURCE=${CMAKE_CURRENT_SOURCE_DIR:-$HERE}

# Add ecbuild to path
export PATH=$SOURCE/../../bin:$PATH
echo $PATH
echo $SOURCE

# --------------------- cleanup ------------------------
$SOURCE/clean.sh

# ----------------- build projectA ---------------------

mkdir -p $HERE/projectA/build && cd $HERE/projectA/build
pwd
ecbuild --prefix=../install -- -Wno-deprecated $SOURCE/projectA
make install
export projectA_ROOT=$HERE/projectA/install

# ----------------- build projectB ---------------------

mkdir -p $HERE/projectB/build && cd $HERE/projectB/build
ecbuild --prefix=../install -- -Wno-deprecated $SOURCE/projectB
make install
export projectB_ROOT=$HERE/projectB/install

# ----------------- build projectC ---------------------

mkdir -p $HERE/projectC/build && cd $HERE/projectC/build
ecbuild --prefix=../install -- -Wno-deprecated $SOURCE/projectC
make install

# ----------------- Run ---------------------

$HERE/projectC/install/bin/main-C
