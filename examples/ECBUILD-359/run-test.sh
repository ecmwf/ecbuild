#!/usr/bin/env bash

HERE="$( cd $( dirname "${BASH_SOURCE[0]}" ) && pwd -P )"

# Cleanup previous builds
rm -rf $HERE/build $HERE/bundle

# Add ecbuild to path
export PATH=$HERE/../../bin:$PATH

# Build and install bundle
mkdir -p $HERE/bundle/build
cd $HERE/bundle/build
ecbuild --prefix=$HERE/bundle/install $HERE/../cpp-bundle
make install

# Build project that uses subproject bar of bundle
mkdir -p $HERE/build
cd $HERE/build
ecbuild -DBAR_PATH=$HERE/bundle/install ../
