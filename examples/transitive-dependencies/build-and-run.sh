#!/usr/bin/env bash

set -e

HERE="$( cd $( dirname "${BASH_SOURCE[0]}" ) && pwd -P )"

# Add ecbuild to path
export PATH=$HERE/../../bin:$PATH

# --------------------- cleanup ------------------------
$HERE/clean.sh

# ----------------- build projectA ---------------------
cd $HERE/projectA

mkdir build
cd build
ecbuild --prefix=../install -- -DINSTALL_LIB_DIR=lib -Wno-deprecated ../
make install

# ----------------- build projectB ---------------------
cd $HERE/projectB

mkdir build
cd build
ecbuild --prefix=../install -- \
    -DprojectA_DIR=$HERE/projectA/install/lib/cmake/projectA \
    -DINSTALL_LIB_DIR=lib -Wno-deprecated ../
make install

# ----------------- build projectC ---------------------
cd $HERE/projectC

mkdir build
cd build
ecbuild --prefix=../install -- \
    -DprojectA_DIR=$HERE/projectA/install/lib/cmake/projectA \
    -DprojectB_DIR=$HERE/projectB/install/lib/cmake/projectB \
    -DINSTALL_LIB_DIR=lib -Wno-deprecated ../
make install

# ----------------- Run ---------------------

cd $HERE
projectC/install/bin/main-C
