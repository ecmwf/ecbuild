# SPDX-FileCopyrightText: 2011- European Centre for Medium-Range Weather Forecasts (ECMWF)
# SPDX-License-Identifier: Apache-2.0

cmake_minimum_required( VERSION 3.18 FATAL_ERROR )

find_package(ecbuild REQUIRED)
project( config_bundle VERSION 0.1 LANGUAGES C )

ecbuild_bundle_initialize()

# Use command "make update" to update branches to latest develop version
ecbuild_bundle( PROJECT subproj1 )
ecbuild_bundle( PROJECT subproj2 )

# Finalize
ecbuild_bundle_finalize()
