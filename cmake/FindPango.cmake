# (C) Copyright 1996-2012 ECMWF.
# 
# This software is licensed under the terms of the Apache Licence Version 2.0
# which can be obtained at http://www.apache.org/licenses/LICENSE-2.0. 
# In applying this licence, ECMWF does not waive the privileges and immunities 
# granted to it by virtue of its status as an intergovernmental organisation nor
# does it submit to any jurisdiction.

# - Try to find Pango

# Output:
#   PANGO_FOUND
#   PANGO_LIBRARIES
#   PANGO_INCLUDE_DIRS

ecbuild_add_extra_search_paths( pango )

find_package(PkgConfig)

pkg_check_modules(PC_LIBPANGO QUIET pango)

set(LIBPANGO_DEFINITIONS ${PC_LIBPANGO_CFLAGS_OTHER})

find_path( LIBPANGO_INCLUDE_DIR NAMES pango/pangocairo.h HINTS ${PC_LIBPANGO_INCLUDE_DIR} ${PC_LIBPANGO_INCLUDE_DIRS} PATH_SUFFIXES pango )
find_library(LIBPANGO_LIBRARY   NAMES pango libpango libpango-1.0 pango-1.0 HINTS ${PC_LIBPANGO_LIBDIR} ${PC_LIBPANGO_LIBRARY_DIRS} )

find_path(GLIB_INCLUDE_DIR NAMES glib.h PATH_SUFFIXES glib-2.0)

set( PANGO_LIBRARIES ${LIBPANGO_LIBRARY} )
set( PANGO_INCLUDE_DIRS ${LIBPANGO_INCLUDE_DIR} ${GLIB_INCLUDE_DIR})

include(FindPackageHandleStandardArgs)

# handle the QUIETLY and REQUIRES arguments and set PANGO_FOUND to TRUE
find_package_handle_standard_args( pango DEFAULT_MSG LIBPANGO_LIBRARY LIBPANGO_INCLUDE_DIR )

mark_as_advanced(LIBPANGO_INCLUDE_DIR LIBPANGO_LIBRARY)
