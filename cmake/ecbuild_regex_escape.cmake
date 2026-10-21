# SPDX-FileCopyrightText: 2011- European Centre for Medium-Range Weather Forecasts (ECMWF)
# SPDX-License-Identifier: Apache-2.0

##############################################################################
#.rst:
#
# ecbuild_regex_escape
# ====================
#
# Escape regular expression special characters from the input string. ::
#
#   ecbuild_regex_escape(<string> <output_variable>)
#
##############################################################################
function(ecbuild_regex_escape input outvar)

    string(REGEX REPLACE "[][.*+?|()\\^$]" "\\\\\\0" output "${input}")
    set(${outvar} "${output}" PARENT_SCOPE)

endfunction(ecbuild_regex_escape)
