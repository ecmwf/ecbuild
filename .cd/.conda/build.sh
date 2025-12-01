#!/usr/bin/env bash

set -eux

SOURCE_DIR=$(pwd)
BUILD_DIR=build
ECBUILD_BIN=$SOURCE_DIR/bin/ecbuild

test -x $(which $ECBUILD_BIN)

rm -rf $BUILD_DIR
mkdir $BUILD_DIR
cd $BUILD_DIR

$ECBUILD_BIN --prefix=$PREFIX --log=DEBUG -- -DINSTALL_LIB_DIR=lib $SOURCE_DIR
make test -j $CPU_COUNT
make install
