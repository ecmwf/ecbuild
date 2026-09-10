# SPDX-FileCopyrightText: 2011- European Centre for Medium-Range Weather Forecasts (ECMWF)
# SPDX-License-Identifier: Apache-2.0

cmake_minimum_required( VERSION 3.18 FATAL_ERROR )

find_package(ecbuild REQUIRED)
project( cpp_bundle VERSION 0.10.0 LANGUAGES C CXX )

ecbuild_bundle_initialize()

ecbuild_bundle( PROJECT foo )
ecbuild_bundle( PROJECT bar )

ecbuild_bundle_finalize()
