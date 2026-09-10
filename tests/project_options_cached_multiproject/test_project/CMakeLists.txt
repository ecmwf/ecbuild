# SPDX-FileCopyrightText: 2011- European Centre for Medium-Range Weather Forecasts (ECMWF)
# SPDX-License-Identifier: Apache-2.0

cmake_minimum_required( VERSION 3.18 FATAL_ERROR )
find_package( ecbuild 3.4 REQUIRED )

project( bundle LANGUAGES NONE VERSION 0.2 )

set ( ENABLE_FEATUREB ON CACHE BOOL "" )
set ( ENABLE_FEATUREC OFF CACHE BOOL "" )

add_subdirectory( proja )
add_subdirectory( projb )

ecbuild_print_summary()