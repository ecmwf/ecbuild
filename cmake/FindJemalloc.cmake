# (C) Copyright 2011- ECMWF.
#
# This software is licensed under the terms of the Apache Licence Version 2.0
# which can be obtained at http://www.apache.org/licenses/LICENSE-2.0.
# In applying this licence, ECMWF does not waive the privileges and immunities
# granted to it by virtue of its status as an intergovernmental organisation nor
# does it submit to any jurisdiction.

##############################################################################
#.rst:
#
# FindJemalloc
# ============
#
# Find the Jemalloc library. ::
#
#   find_package( Jemalloc [REQUIRED] [QUIET] )
#
# Output variables
# ----------------
#
# The following CMake variables are set on completion:
#
# :Jemalloc_FOUND:        true if Jemalloc is found on the system
# :JEMALLOC_LIBRARIES:    full paths to requested Jemalloc libraries
# :JEMALLOC_INCLUDE_DIRS: Jemalloc include directory
#
# Input variables
# ---------------
#
# The following CMake and environment variables are considered:
#
# :Jemalloc_ROOT:
#
##############################################################################

find_library( JEMALLOC_LIBRARIES NAMES jemalloc )
find_path( JEMALLOC_INCLUDE_DIRS NAMES jemalloc/jemalloc.h )

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(Jemalloc DEFAULT_MSG
    JEMALLOC_LIBRARIES
    JEMALLOC_INCLUDE_DIRS
)
if( JEMALLOC_LIBRARIES )
  get_filename_component( JEMALLOC_LIBRARY_DIR ${JEMALLOC_LIBRARIES} DIRECTORY )
endif()
mark_as_advanced(
    JEMALLOC_INCLUDE_DIRS
    JEMALLOC_LIBRARIES
    JEMALLOC_LIBRARY_DIR
)
