# SPDX-FileCopyrightText: 2011- European Centre for Medium-Range Weather Forecasts (ECMWF)
# SPDX-License-Identifier: Apache-2.0

set(_foo_FOUND 1)
set(_foo_VERSION 1.2.3 )
include( FindPackageHandleStandardArgs )
find_package_handle_standard_args( foo
  REQUIRED_VARS _foo_FOUND
  VERSION_VAR   _foo_VERSION
)
