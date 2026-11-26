#!/usr/bin/env bash

# SPDX-FileCopyrightText: 2011- European Centre for Medium-Range Weather Forecasts (ECMWF)
# SPDX-License-Identifier: Apache-2.0

set -e

HERE=${CMAKE_CURRENT_BINARY_DIR:-"$( cd $( dirname "${BASH_SOURCE[0]}" ) && pwd -P )"}
SOURCE=${CMAKE_CURRENT_SOURCE_DIR:-$HERE}

# Add ecbuild to path
export PATH=$SOURCE/../../bin:$PATH

ecbuild $SOURCE/test_project -B $HERE/build

# The PROCESSORS property of a test, or "unset"
processors() {
  (cd $HERE/build; ctest -R "^$1\$" --show-only=json-v1) \
    | tr -d ' \n' | grep -o '"name":"PROCESSORS","value":[0-9]*' | grep -o '[0-9]*$' || echo unset
}

check() {
  local got
  got=$(processors $1)
  echo "$1: PROCESSORS $got, expected $2"
  [ "$got" = "$2" ]
}

check serial unset
check omp4 4
check mpi2_omp3 6
check mpi2_overridden 3
