# SPDX-FileCopyrightText: 2011- European Centre for Medium-Range Weather Forecasts (ECMWF)
# SPDX-License-Identifier: Apache-2.0

set( CMAKE_C_FLAGS_RELEASE        "-O3 -hfp3 -hscalar3 -hvector3 -DNDEBUG"        CACHE STRING "Release C flags"                  FORCE )
set( CMAKE_C_FLAGS_RELWITHDEBINFO "-O2 -hfp1 -G2 -DNDEBUG"                        CACHE STRING "Release-with-debug-info C flags"  FORCE )
set( CMAKE_C_FLAGS_PRODUCTION     "-O2 -hfp1 -G2"                                 CACHE STRING "Production C flags"               FORCE )
set( CMAKE_C_FLAGS_BIT            "-O2 -hfp1 -G2 -hflex_mp=conservative -DNDEBUG" CACHE STRING "Bit-reproducible C flags"         FORCE )
set( CMAKE_C_FLAGS_DEBUG          "-O0 -G0"                                       CACHE STRING "Debug Cflags"                     FORCE )
