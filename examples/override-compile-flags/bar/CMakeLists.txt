# SPDX-FileCopyrightText: 2011- European Centre for Medium-Range Weather Forecasts (ECMWF)
# SPDX-License-Identifier: Apache-2.0

cmake_minimum_required( VERSION 3.18 FATAL_ERROR )

find_package( ecbuild REQUIRED )
project( bar VERSION 0.2 LANGUAGES C )

### targets

ecbuild_add_library( TARGET bar SOURCES bar.c )

ecbuild_install_project( NAME ${PROJECT_NAME} )

ecbuild_print_summary()
