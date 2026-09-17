#!/usr/bin/env bash

# SPDX-FileCopyrightText: 2011- European Centre for Medium-Range Weather Forecasts (ECMWF)
# SPDX-License-Identifier: Apache-2.0

set -e

HERE=${CMAKE_CURRENT_BINARY_DIR:-"$( cd $( dirname "${BASH_SOURCE[0]}" ) && pwd -P )"}

# --------------------- cleanup ------------------------
echo "cleaning $HERE"
rm -rf $HERE/build
rm -f $HERE/*.log
