# SPDX-FileCopyrightText: 2026- European Centre for Medium-Range Weather Forecasts (ECMWF)
# SPDX-License-Identifier: Apache-2.0

cmake_minimum_required(VERSION 3.18 FATAL_ERROR)
find_package(ecbuild REQUIRED)
project(pkgconfig_incremental VERSION 0.1 LANGUAGES NONE)

add_library(example INTERFACE)
ecbuild_pkgconfig(NAME example LIBRARIES example)

# A call from a subdirectory configures its script below that directory.
add_subdirectory(sub)
