# SPDX-FileCopyrightText: 2011- European Centre for Medium-Range Weather Forecasts (ECMWF)
# SPDX-License-Identifier: Apache-2.0

set( CMAKE_Fortran_FLAGS_RELEASE        "-O3 -DNDEBUG -funroll-all-loops -finline-functions" CACHE STRING "Fortran compiler flags for Release builds"          FORCE )
set( CMAKE_Fortran_FLAGS_BIT            "-O2 -DNDEBUG -fno-range-check"                      CACHE STRING "Fortran compiler flags for Bit-reproducible builds" FORCE )
set( CMAKE_Fortran_FLAGS_DEBUG          "-O0 -g -fcheck=bounds -fbacktrace -finit-real=snan" CACHE STRING "Fortran compiler flags for Debug builds"            FORCE )
set( CMAKE_Fortran_FLAGS_PRODUCTION     "-O2 -g"                                             CACHE STRING "Fortran compiler flags for Production builds."      FORCE )
set( CMAKE_Fortran_FLAGS_RELWITHDEBINFO "-O2 -g -DNDEBUG"                                    CACHE STRING "Fortran compiler flags for RelWithDebInfo builds."  FORCE )

set( Fortran_FLAG_STACK_ARRAYS "-fstack-arrays" )

####################################################################

# Meaning of flags
# ----------------
# -fstack-arrays     : Allocate automatic arrays on the stack (needs large stacksize!!!)
# -funroll-all-loops : Unroll all loops
# -fcheck=bounds     : Bounds checking
