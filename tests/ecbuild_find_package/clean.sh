#!/usr/bin/env bash

set -e

HERE=${CMAKE_CURRENT_BINARY_DIR:-"$( cd $( dirname "${BASH_SOURCE[0]}" ) && pwd -P )"}

# --------------------- cleanup ------------------------
echo "cleaning $HERE"
rm -rf $HERE/projectA/build
rm -rf $HERE/projectA/install
rm -rf $HERE/projectB/build
rm -rf $HERE/projectB/install
rm -rf $HERE/projectC/build
rm -rf $HERE/projectC/install

