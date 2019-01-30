# (C) Copyright 2019- ECMWF.
#
# This software is licensed under the terms of the Apache Licence Version 2.0
# which can be obtained at http://www.apache.org/licenses/LICENSE-2.0.
# In applying this licence, ECMWF does not waive the privileges and immunities
# granted to it by virtue of its status as an intergovernmental organisation nor
# does it submit to any jurisdiction.

####################################################################################################
# include our cmake macros, but only do so if this is the top project
if(ECBUILD_2_COMPAT AND PROJECT_NAME STREQUAL CMAKE_PROJECT_NAME)
  if(ECBUILD_2_COMPAT_DEPRECATE)
    ecbuild_deprecate("The ecbuild 2 compatibility layer is deprecated. "
      "Please upgrade the build system and unset `ECBUILD_2_COMPAT`.")
  endif()

  # include macros here
endif()
