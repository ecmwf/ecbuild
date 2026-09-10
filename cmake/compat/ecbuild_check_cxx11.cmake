# SPDX-FileCopyrightText: 2011- European Centre for Medium-Range Weather Forecasts (ECMWF)
# SPDX-License-Identifier: Apache-2.0

##############################################################################
#.rst:
#
# ecbuild_check_cxx11
# ===================
#
# REMOVED
##############################################################################

function(ecbuild_check_cxx11)

  if(ECBUILD_COMPAT_DEPRECATE)
    ecbuild_deprecate("The ecbuild_check_cxx11 has been removed. Please use "
      "CMake facilities for C++11 features")
  endif()

endfunction(ecbuild_check_cxx11)
