# SPDX-FileCopyrightText: 2011- European Centre for Medium-Range Weather Forecasts (ECMWF)
# SPDX-License-Identifier: Apache-2.0

set(projectB_FOO spam)

if(TARGET libB)
  message(FATAL_ERROR "libB should not be defined yet")
else()
  message("libB not defined yet, as expected")
endif()
