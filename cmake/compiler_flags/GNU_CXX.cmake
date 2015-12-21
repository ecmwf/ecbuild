# (C) Copyright 1996-2015 ECMWF.
#
# This software is licensed under the terms of the Apache Licence Version 2.0
# which can be obtained at http://www.apache.org/licenses/LICENSE-2.0.
# In applying this licence, ECMWF does not waive the privileges and immunities
# granted to it by virtue of its status as an intergovernmental organisation nor
# does it submit to any jurisdiction.

set( CMAKE_CXX_FLAGS_RELEASE "-O3 -DNDEBUG" CACHE STRING "Release C++ compiler flags" FORCE )
set( CMAKE_CXX_FLAGS_BIT "-O2 -DNDEBUG" CACHE STRING "Bit-reproducible C++ compiler flags" FORCE )
set( CMAKE_CXX_FLAGS_DEBUG "-O0 -g -ftrapv" CACHE STRING "Debug C++ compiler flags" FORCE )
set( CMAKE_CXX_FLAGS_PRODUCTION "-O2 -g" CACHE STRING "Flags used by the C++ compiler during Production builds." FORCE )
set( CMAKE_CXX_LINK_FLAGS "" CACHE STRING "" FORCE )

# NOTE: gcc does not guarrante that -O3 performs better than -O2
#       -- it can perform worse due to assembly code bloating.
#   Moreover for gcc 4.1.2 we found that -O3 remove the parser code generated from Lex/Yacc
#   and therefore in production mode we downgrade to -O2 if the compiler is GCC (for all versions).
