# SPDX-FileCopyrightText: 2011- European Centre for Medium-Range Weather Forecasts (ECMWF)
# SPDX-License-Identifier: Apache-2.0

############################################################################################
# define custom properties

############################################################################################
# source properties:

# Custom property to determine if compiler flags have been applied yet:
define_property( SOURCE
  PROPERTY CUSTOM_FLAGS
  BRIEF_DOCS "Custom compiler flags have been applied to source file"
  FULL_DOCS "Compiler flags have been applied to the source file, using custom CMake rules. Assists processing of sources that are used by multiple targets. Treated as Boolean." )
