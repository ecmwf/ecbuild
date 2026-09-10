# SPDX-FileCopyrightText: 2011- European Centre for Medium-Range Weather Forecasts (ECMWF)
# SPDX-License-Identifier: Apache-2.0

set( CMAKE_CXX_FLAGS_RELEASE        "-O3 -DNDEBUG"    CACHE STRING "C++ compiler flags for Release builds"          FORCE )
set( CMAKE_CXX_FLAGS_BIT            "-O2 -DNDEBUG"    CACHE STRING "C++ compiler flags for Bit-reproducible builds" FORCE )
set( CMAKE_CXX_FLAGS_DEBUG          "-O0 -g"          CACHE STRING "C++ compiler flags for Debug builds"            FORCE )
set( CMAKE_CXX_FLAGS_PRODUCTION     "-O3 -g"          CACHE STRING "C++ compiler flags for Production builds."      FORCE )
set( CMAKE_CXX_FLAGS_RELWITHDEBINFO "-O2 -g -DNDEBUG" CACHE STRING "C++ compiler flags for RelWithDebInfo builds."  FORCE )
