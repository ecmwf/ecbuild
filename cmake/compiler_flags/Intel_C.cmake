# SPDX-FileCopyrightText: 2011- European Centre for Medium-Range Weather Forecasts (ECMWF)
# SPDX-License-Identifier: Apache-2.0

set( CMAKE_C_FLAGS_RELEASE        "-O3 -DNDEBUG"      CACHE STRING "Release C compiler flags"                  FORCE )
set( CMAKE_C_FLAGS_BIT            "-O2 -DNDEBUG"      CACHE STRING "Bit-reproducible C compiler flags"         FORCE )
set( CMAKE_C_FLAGS_DEBUG          "-O0 -g -traceback" CACHE STRING "Debug C compiler flags"                    FORCE )
set( CMAKE_C_FLAGS_PRODUCTION     "-O3 -g"            CACHE STRING "Production C compiler flags"               FORCE )
set( CMAKE_C_FLAGS_RELWITHDEBINFO "-O2 -g -DNDEBUG"   CACHE STRING "Release-with-debug-info C compiler flags"  FORCE )
