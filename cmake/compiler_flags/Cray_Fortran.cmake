# (C) Copyright 1996-2015 ECMWF.
#
# This software is licensed under the terms of the Apache Licence Version 2.0
# which can be obtained at http://www.apache.org/licenses/LICENSE-2.0.
# In applying this licence, ECMWF does not waive the privileges and immunities
# granted to it by virtue of its status as an intergovernmental organisation nor
# does it submit to any jurisdiction.

set( CMAKE_Fortran_FLAGS_ALL            "-emf -rmoid" CACHE STRING "" FORCE )
set( CMAKE_Fortran_FLAGS_RELEASE        "${CMAKE_Fortran_FLAGS_ALL} -O3 -hfp3 -hscalar3 -hvector3" CACHE STRING "Release Fortran flags" FORCE )
set( CMAKE_Fortran_FLAGS_RELWITHDEBINFO "${CMAKE_Fortran_FLAGS_ALL} -O2 -hfp1 -Gfast" CACHE STRING "Release-with-debug-info Fortran flags" FORCE )
set( CMAKE_Fortran_FLAGS_PRODUCTION     "${CMAKE_Fortran_FLAGS_ALL} -O2 -hfp1 -G2" CACHE STRING "Production Fortran flags" FORCE )
set( CMAKE_Fortran_FLAGS_BIT            "${CMAKE_Fortran_FLAGS_ALL} -O2 -hfp1 -G2 -hflex_mp=conservative -hadd_paren" CACHE STRING "Bit-reproducible Fortran flags" FORCE )
set( CMAKE_Fortran_FLAGS_DEBUG          "${CMAKE_Fortran_FLAGS_ALL} -O0 -G0" CACHE STRING "Debug Fortran flags" FORCE )

set( CMAKE_Fortran_LINK_FLAGS  "-Wl,-Map,loadmap -Wl,--as-needed" CACHE STRING "" FORCE )
