# SPDX-FileCopyrightText: 2011- European Centre for Medium-Range Weather Forecasts (ECMWF)
# SPDX-License-Identifier: Apache-2.0

set( Fortran_AUTOMATIC_ARRAYS_LIMIT 32768 )  # (32 kb)
math( EXPR Fortran_AUTOMATIC_ARRAYS_LIMIT_KB "${Fortran_AUTOMATIC_ARRAYS_LIMIT}/1024" )

set( Fortran_FLAG_STACK_ARRAYS     "-no-heap-arrays" )
set( Fortran_FLAG_AUTOMATIC_ARRAYS "-heap-arrays ${Fortran_AUTOMATIC_ARRAYS_LIMIT_KB}" )

set( CMAKE_Fortran_FLAGS_RELEASE        "-O3 -DNDEBUG -unroll -inline ${Fortran_FLAG_AUTOMATIC_ARRAYS}" CACHE STRING "Release Fortran flags"                 FORCE )
set( CMAKE_Fortran_FLAGS_RELWITHDEBINFO "-O2 -g -DNDEBUG ${Fortran_FLAG_AUTOMATIC_ARRAYS}"              CACHE STRING "Release-with-debug-info Fortran flags" FORCE )
set( CMAKE_Fortran_FLAGS_BIT            "-O2 -DNDEBUG -unroll -inline ${Fortran_FLAG_AUTOMATIC_ARRAYS}" CACHE STRING "Bit-reproducible Fortran flags"        FORCE )
set( CMAKE_Fortran_FLAGS_DEBUG          "-O0 -g -traceback ${Fortran_FLAG_AUTOMATIC_ARRAYS} -check all" CACHE STRING "Debug Fortran flags"                   FORCE )
set( CMAKE_Fortran_FLAGS_PRODUCTION     "-O3 -g ${Fortran_FLAG_AUTOMATIC_ARRAYS}"                       CACHE STRING "Production Fortran compiler flags"     FORCE )

# "-check all" implies "-check bounds"
