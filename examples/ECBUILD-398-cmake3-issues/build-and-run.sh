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
ecbuild --prefix=../install -- -Wno-deprecated -DECBUILD_2_COMPAT=OFF ../
make install

# ----------------- build projectB ---------------------
cd $HERE/projectB

mkdir build
cd build
ecbuild --prefix=../install -- \
    -DprojectA_DIR=$HERE/projectA/install/lib/cmake/projectA \
    -Wno-deprecated -DECBUILD_2_COMPAT=OFF ../
make install

# ----------------- build projectC ---------------------
cd $HERE/projectC

mkdir build
cd build
ecbuild --prefix=../install -- \
    -DprojectA_DIR=$HERE/projectA/install/lib/cmake/projectA \
    -DprojectB_DIR=$HERE/projectB/install/lib/cmake/projectB \
    -Wno-deprecated -DECBUILD_2_COMPAT=OFF ../
make install

# ----------------- Run ---------------------

cd $HERE
projectC/install/bin/main-C

# This should not have any issues running.
