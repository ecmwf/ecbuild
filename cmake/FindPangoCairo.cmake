# (C) Copyright 1996-2012 ECMWF.
# 
# This software is licensed under the terms of the Apache Licence Version 2.0
# which can be obtained at http://www.apache.org/licenses/LICENSE-2.0. 
# In applying this licence, ECMWF does not waive the privileges and immunities 
# granted to it by virtue of its status as an intergovernmental organisation nor
# does it submit to any jurisdiction.

# - Try to find PangoCairo

# Output:
#   PANGOCAIRO_FOUND
#   PANGOCAIRO_LIBRARIES
#   PANGOCAIRO_INCLUDE_DIRS


find_package(PkgConfig)

pkg_check_modules(PC_LIBPANGOCAIRO QUIET pangocairo)

debug_var( PC_LIBPANGOCAIRO_FOUND )
debug_var( PC_LIBPANGOCAIRO_VERSION )
debug_var( PC_LIBPANGOCAIRO_LIBRARIES )
debug_var( PC_LIBPANGOCAIRO_INCLUDE_DIRS )

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args( pangocairo DEFAULT_MSG PC_LIBPANGOCAIRO_LIBRARIES PC_LIBPANGOCAIRO_INCLUDE_DIRS )

set( PANGOCAIRO_VERSION ${PC_LIBPANGOCAIRO_VERSION} )
set( PANGOCAIRO_LIBRARIES ${PC_LIBPANGOCAIRO_LIBRARIES} )
set( PANGOCAIRO_INCLUDE_DIRS ${PC_LIBPANGOCAIRO_INCLUDE_DIRS} )

