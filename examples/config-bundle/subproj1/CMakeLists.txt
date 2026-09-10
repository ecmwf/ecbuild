# SPDX-FileCopyrightText: 2011- European Centre for Medium-Range Weather Forecasts (ECMWF)
# SPDX-License-Identifier: Apache-2.0

cmake_minimum_required( VERSION 3.18 FATAL_ERROR )

find_package(ecbuild REQUIRED)
project( subproj_1 VERSION 0.1 LANGUAGES C )

ecbuild_debug_var( CMAKE_C_FLAGS )
ecbuild_debug_var( CMAKE_C_FLAGS_DEBUG )
