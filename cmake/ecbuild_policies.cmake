# SPDX-FileCopyrightText: 2011- European Centre for Medium-Range Weather Forecasts (ECMWF)
# SPDX-License-Identifier: Apache-2.0

##############################################################################
#
# ecBuild Policies
# ================
#
# NOTE: This file needs to be included with NO_POLICY_SCOPE or it will have no
#       effect!
#
##############################################################################

if( NOT ${PROJECT_NAME}_ECBUILD_POLICIES_INCLUDED )
set( ${PROJECT_NAME}_ECBUILD_POLICIES_INCLUDED TRUE )

if( ECBUILD_2_COMPAT )
  # Allow mixed use of plain and keyword target_link_libraries
  cmake_policy( SET CMP0023 OLD )
  # Allow use of the LOCATION target property.
  cmake_policy( SET CMP0026 OLD )
  # Do not manage VERSION variables in project command
  cmake_policy( SET CMP0048 OLD )
  # RPATH settings on macOS do not affect "install_name"
  # FTM, keep old behavior -- need to test if new behavior impacts binaries in build directory
  cmake_policy( SET CMP0068 OLD )
else()
  # we set these to avoid warnings
  cmake_policy( SET CMP0048 NEW ) # introduced in cmake 3.0
  cmake_policy( SET CMP0068 NEW ) # introduced in cmake 3.9
endif()

# for macosx use @rpath in a target’s install name (CMP0042)
set( CMAKE_MACOSX_RPATH ON )

# find packages use <package>_ROOT by default, new in version 3.12
if( POLICY CMP0074 )
    cmake_policy( SET CMP0074 NEW )
endif()

# Detect invalid indices in the ``list()`` command, new in version 3.21
if( POLICY CMP0121 )
    cmake_policy( SET CMP0121 NEW )
endif()

endif()
