#!/usr/bin/env bash

set -e

HERE=${CMAKE_CURRENT_BINARY_DIR:-"$( cd $( dirname "${BASH_SOURCE[0]}" ) && pwd -P )"}

# --------------------- cleanup ------------------------
echo "cleaning $HERE"
rm -rf $HERE/build
rm -f $HERE/*.log
