#!/usr/bin/env bash

# SPDX-FileCopyrightText: 2011- European Centre for Medium-Range Weather Forecasts (ECMWF)
# SPDX-License-Identifier: Apache-2.0

set -e

HERE="$( cd $( dirname "${BASH_SOURCE[0]}" ) && pwd -P )"

# --------------------- cleanup ------------------------

rm -rf projectA/build
rm -rf projectA/install
rm -rf projectB/build
rm -rf projectB/install
rm -rf projectC/build
rm -rf projectC/install

