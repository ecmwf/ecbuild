# SPDX-FileCopyrightText: 2011- European Centre for Medium-Range Weather Forecasts (ECMWF)
# SPDX-License-Identifier: Apache-2.0

#Sets:
# DL_LIBRARIES      = the library to link against (RT etc)

if( DEFINED DL_PATH )
    find_library(DL_LIBRARIES dl PATHS ${DL_PATH}/lib NO_DEFAULT_PATH )
endif()

find_library(DL_LIBRARIES dl )

include(FindPackageHandleStandardArgs)

# handle the QUIET and REQUIRED arguments and set DL_FOUND to TRUE
# if all listed variables are TRUE
# Note: capitalisation of the package name must be the same as in the file name
find_package_handle_standard_args(Dl DEFAULT_MSG DL_LIBRARIES )
