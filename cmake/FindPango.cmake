# (C) Copyright 1996-2012 ECMWF.
# 
# This software is licensed under the terms of the Apache Licence Version 2.0
# which can be obtained at http://www.apache.org/licenses/LICENSE-2.0. 
# In applying this licence, ECMWF does not waive the privileges and immunities 
# granted to it by virtue of its status as an intergovernmental organisation nor
# does it submit to any jurisdiction.

# - Try to find Pango


set(PANGO_VERSION 1.0)


find_path(PANGO_INCLUDE_DIR NAMES pangocairo.h HINTS /usr/include/pango-${PANGO_VERSION}/pango)
find_library(PANGO_LIBRARY NAMES libpango-${PANGO_VERSION}.so)

include(FindPackageHandleStandardArgs)

find_package_handle_standard_args(PANGO  DEFAULT_MSG
	PANGO_LIBRARY PANGO_INCLUDE_DIR)

mark_as_advanced(PANGO_INCLUDE_DIR PANGO_LIBRARY)
