# (C) Copyright 1996-2015 ECMWF.
#
# This software is licensed under the terms of the Apache Licence Version 2.0
# which can be obtained at http://www.apache.org/licenses/LICENSE-2.0.
# In applying this licence, ECMWF does not waive the privileges and immunities
# granted to it by virtue of its status as an intergovernmental organisation nor
# does it submit to any jurisdiction.

set( CMAKE_C_FLAGS         "-Ktrap=fp -h list=amid" CACHE STRING "Common C flags for all build types" FORCE )
set( CMAKE_C_FLAGS_RELEASE "-O3 -hfp3 -hscalar3 -hvector3" CACHE STRING "Release C flags" FORCE )
set( CMAKE_C_FLAGS_BIT     "-O2 -hflex_mp=conservative -hadd_paren -hfp1" CACHE STRING "Bit-reproducible C flags" )
set( CMAKE_C_FLAGS_DEBUG   "-O0 -Gfast" CACHE STRING "Debug C flags" FORCE )
set( CMAKE_C_LINK_FLAGS    "-Wl,-Map,loadmap" CACHE STRING "" FORCE )
