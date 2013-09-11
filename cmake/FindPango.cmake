# (C) Copyright 1996-2012 ECMWF.
# 
# This software is licensed under the terms of the Apache Licence Version 2.0
# which can be obtained at http://www.apache.org/licenses/LICENSE-2.0. 
# In applying this licence, ECMWF does not waive the privileges and immunities 
# granted to it by virtue of its status as an intergovernmental organisation nor
# does it submit to any jurisdiction.

# - Try to find Pango

include(FindPackageHandleStandardArgs)

find_path(PANGO_INCLUDE_DIR NAMES pangocairo.h HINTS /usr/include/pango-1.0/pango)
find_library(PANGO_LIBRARY NAMES libpango-1.0.so)

message(status "PANGO" ${PANGO_INCLUDE_DIR} ${PANGO_LIBRARY})

mark_as_advanced(PANGO_INCLUDE_DIR PANGO_LIBRARY)
