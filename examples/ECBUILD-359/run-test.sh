#!/usr/bin/env bash

# (C) Copyright 1996 ECMWF.
#
# This software is licensed under the terms of the Apache Licence Version 2.0
# which can be obtained at http://www.apache.org/licenses/LICENSE-2.0.
# In applying this licence, ECMWF does not waive the privileges and immunities
# granted to it by virtue of its status as an intergovernmental organisation
# nor does it submit to any jurisdiction.

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
