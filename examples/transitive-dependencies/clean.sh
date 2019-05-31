#!/usr/bin/env bash

set -e

HERE="$( cd $( dirname "${BASH_SOURCE[0]}" ) && pwd -P )"

# --------------------- cleanup ------------------------

rm -rf projectA/build
rm -rf projectA/install
rm -rf projectB/build
rm -rf projectB/install
rm -rf projectC/build
rm -rf projectC/install

