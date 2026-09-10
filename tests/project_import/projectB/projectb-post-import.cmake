# SPDX-FileCopyrightText: 2011- European Centre for Medium-Range Weather Forecasts (ECMWF)
# SPDX-License-Identifier: Apache-2.0

set(projectB_BAR eggs)

if(NOT TARGET libB)
  message(FATAL_ERROR "libB not defined")
else()
  message("libB defined as expected")
endif()
