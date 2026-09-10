# SPDX-FileCopyrightText: 2011- European Centre for Medium-Range Weather Forecasts (ECMWF)
# SPDX-License-Identifier: Apache-2.0

cmake_minimum_required( VERSION 3.18 FATAL_ERROR )

find_package(ecbuild 3.4 REQUIRED)
project(bundleAB VERSION 0.1.0 LANGUAGES C)

ecbuild_bundle(PROJECT projectA)
ecbuild_bundle(PROJECT projectB)

ecbuild_install_project(NAME ${PROJECT_NAME})
