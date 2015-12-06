# (C) Copyright 1996-2015 ECMWF.
#
# This software is licensed under the terms of the Apache Licence Version 2.0
# which can be obtained at http://www.apache.org/licenses/LICENSE-2.0.
# In applying this licence, ECMWF does not waive the privileges and immunities
# granted to it by virtue of its status as an intergovernmental organisation nor
# does it submit to any jurisdiction.

set( CMAKE_C_FLAGS "" CACHE STRING "Common C compiler flags" FORCE )
set( CMAKE_C_FLAGS_RELEASE "-O3 -DNDEBUG" CACHE STRING "Release C compiler flags" FORCE )
set( CMAKE_C_FLAGS_BIT "-O2 -DNDEBUG" CACHE STRING "Bit-reproducible C compiler flags" FORCE )
set( CMAKE_C_FLAGS_DEBUG "-O0 -g -ftrapv" CACHE STRING "Debug C compiler flags" FORCE )
set( CMAKE_C_LINK_FLAGS "" CACHE STRING "" FORCE )
