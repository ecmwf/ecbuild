# SPDX-FileCopyrightText: 2011- European Centre for Medium-Range Weather Forecasts (ECMWF)
# SPDX-License-Identifier: Apache-2.0

#Sets:
# CMATH_LIBRARIES      = the library to link against (RT etc)

IF(UNIX)
  if( DEFINED CMATH_PATH )
    find_library(CMATH_LIBRARIES m PATHS ${CMATH_PATH}/lib NO_DEFAULT_PATH )
  endif()

  find_library(CMATH_LIBRARIES m )

  include(FindPackageHandleStandardArgs)

  # handle the QUIET and REQUIRED arguments and set CMATH_FOUND to TRUE
  # if all listed variables are TRUE
  # Note: capitalisation of the package name must be the same as in the file name
  find_package_handle_standard_args(CMath DEFAULT_MSG CMATH_LIBRARIES )

ENDIF(UNIX)
