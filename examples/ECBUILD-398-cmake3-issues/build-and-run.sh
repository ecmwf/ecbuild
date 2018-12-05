#!/usr/bin/env bash

set -e

HERE="$( cd $( dirname "${BASH_SOURCE[0]}" ) && pwd -P )"

# Add ecbuild to path
export PATH=$HERE/../../bin:$PATH

# --------------------- cleanup ------------------------
$HERE/clean.sh

unset CMAKE_FLAGS

# ECBUILD-399 : We want to use relative rpaths but this breaks on LXC and LXG
#    Change to OFF to make it work on LXC and LXG
CMAKE_FLAGS="$CMAKE_FLAGS -DENABLE_RELATIVE_RPATHS=ON"

# ----------------- build projectA ---------------------
cd $HERE/projectA

mkdir build
cd build
ecbuild --prefix=../install -- $CMAKE_FLAGS ../
make install

# ----------------- build projectB ---------------------
cd $HERE/projectB

mkdir build
cd build
ecbuild --prefix=../install -- \
    -DprojectA_DIR=$HERE/projectA/install/share/projectA/cmake \
    $CMAKE_FLAGS ../
make install

# ----------------- build projectC ---------------------
cd $HERE/projectC

mkdir build
cd build
ecbuild --prefix=../install -- \
    -DprojectA_DIR=$HERE/projectA/install/share/projectA/cmake \
    -DprojectB_DIR=$HERE/projectB/install/share/projectB/cmake \
    $CMAKE_FLAGS ../
make install

# ----------------- Run ---------------------

cd $HERE
projectC/install/bin/main-C

# This should not have any issues running. On LXG and LXC there are issues with ENABLE_RELATIVE_RPATHS=ON
