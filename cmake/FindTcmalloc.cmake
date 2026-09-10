# SPDX-FileCopyrightText: 2011- European Centre for Medium-Range Weather Forecasts (ECMWF)
# SPDX-License-Identifier: Apache-2.0

##############################################################################
#.rst:
#
# FindTcmalloc
# ============
#
# Find the Tcmalloc library. ::
#
#   find_package( Tcmalloc [REQUIRED] [QUIET] )
#
# Output variables
# ----------------
#
# The following CMake variables are set on completion:
#
# :Tcmalloc_FOUND:        true if Tcmalloc is found on the system
# :TCMALLOC_LIBRARIES:    full paths to requested Tcmalloc libraries
# :TCMALLOC_LIBRARY_DIR:  Directory containing the TCMALLOC_LIBRARIES
# :TCMALLOC_INCLUDE_DIRS: Tcmalloc include directories
#
# Input variables
# ---------------
#
# The following CMake / Environment variables are considered in order:
#
# :Tcmalloc_ROOT: CMake variable / Environment variable
#
##############################################################################

find_library( TCMALLOC_LIBRARIES NAMES tcmalloc )
find_path( TCMALLOC_INCLUDE_DIRS NAMES gperftools/tcmalloc.h )
if( TCMALLOC_LIBRARIES )
  get_filename_component( TCMALLOC_LIBRARY_DIR ${TCMALLOC_LIBRARIES} DIRECTORY )
endif()

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(Tcmalloc DEFAULT_MSG
    TCMALLOC_LIBRARIES
    TCMALLOC_INCLUDE_DIRS
)

mark_as_advanced(
    TCMALLOC_LIBRARIES
    TCMALLOC_INCLUDE_DIRS
    TCMALLOC_LIBRARY_DIR
)
