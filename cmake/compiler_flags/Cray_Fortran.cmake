# (C) Copyright 1996-2016 ECMWF.
#
# This software is licensed under the terms of the Apache Licence Version 2.0
# which can be obtained at http://www.apache.org/licenses/LICENSE-2.0.
# In applying this licence, ECMWF does not waive the privileges and immunities
# granted to it by virtue of its status as an intergovernmental organisation
# nor does it submit to any jurisdiction.

# -emf activates .mods and uses lower case
# -rmoid produces a listing file
set( CMAKE_Fortran_FLAGS_RELEASE        "-emf -rmoid -O3 -hfp3 -hscalar3 -hvector3 -DNDEBUG"                    CACHE STRING "Release Fortran flags"                 FORCE )
set( CMAKE_Fortran_FLAGS_RELWITHDEBINFO "-emf -rmoid -O2 -hfp1 -Gfast -DNDEBUG"                                 CACHE STRING "Release-with-debug-info Fortran flags" FORCE )
set( CMAKE_Fortran_FLAGS_PRODUCTION     "-emf -rmoid -O2 -hfp1 -G2"                                             CACHE STRING "Production Fortran flags"              FORCE )
set( CMAKE_Fortran_FLAGS_BIT            "-emf -rmoid -O2 -hfp1 -G2 -hflex_mp=conservative -hadd_paren -DNDEBUG" CACHE STRING "Bit-reproducible Fortran flags"        FORCE )
set( CMAKE_Fortran_FLAGS_DEBUG          "-emf -rmoid -O0 -G0"                                                   CACHE STRING "Debug Fortran flags"                   FORCE )
