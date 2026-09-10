# SPDX-FileCopyrightText: 2011- European Centre for Medium-Range Weather Forecasts (ECMWF)
# SPDX-License-Identifier: Apache-2.0

get_filename_component(ecbuild_MACROS_DIR ${CMAKE_CURRENT_LIST_DIR} ABSOLUTE)
cmake_policy( PUSH )
cmake_policy( SET CMP0057 NEW )
if(NOT ${ecbuild_MACROS_DIR} IN_LIST CMAKE_MODULE_PATH)
    list(INSERT CMAKE_MODULE_PATH 0 ${ecbuild_MACROS_DIR})
endif()
cmake_policy( POP )
include(ecbuild)

