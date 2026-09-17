# SPDX-FileCopyrightText: 2011- European Centre for Medium-Range Weather Forecasts (ECMWF)
# SPDX-License-Identifier: Apache-2.0

cmake_minimum_required( VERSION 3.18 FATAL_ERROR )

find_package( ecbuild REQUIRED )
project( test_interface_library VERSION 0.1.0 LANGUAGES C )

ecbuild_add_library( TARGET intfb_lib TYPE INTERFACE
                     PUBLIC_INCLUDES 
                        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}>
                        $ENV{HOME}
                     PUBLIC_LIBS some_lib
                     PUBLIC_DEFINITIONS MYDEF=1
                    )
ecbuild_install_project( NAME test_interface_library )
