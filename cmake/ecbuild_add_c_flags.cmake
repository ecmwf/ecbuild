# SPDX-FileCopyrightText: 2011- European Centre for Medium-Range Weather Forecasts (ECMWF)
# SPDX-License-Identifier: Apache-2.0

##############################################################################
#.rst:
#
# ecbuild_add_c_flags
# ===================
#
# Add C compiler flags to CMAKE_C_FLAGS only if supported by the compiler. ::
#
#   ecbuild_add_c_flags( <flag1> [ <flag2> ... ]
#                        [ BUILD <build> ]
#                        [ NAME <name> ]
#                        [ NO_FAIL ]
#                        [ PROJECT ] )
#
# Options
# -------
#
# BUILD : optional
#   add flags to ``CMAKE_C_FLAGS_<build>`` instead of ``CMAKE_C_FLAGS``
#
# NAME : optional
#   name of the check (if omitted, checks are enumerated)
#
# NO_FAIL : optional
#   do not fail if the flag cannot be added
#
# PROJECT : optional
#   add flags to project specific ``${PNAME}_C_FLAGS`` and
#   ``${PNAME}_C_FLAGS_<build>`` instead of the corresponding
#   ``CMAKE_C_FLAGS`` variables.
#
##############################################################################

include(ecbuild_add_lang_flags)

macro( ecbuild_add_c_flags )
    ecbuild_debug("call ecbuild_add_c_flags( ${ARGV} )")
    ecbuild_add_lang_flags( FLAGS ${ARGV} LANG C )
endmacro()

macro( cmake_add_c_flags )
  ecbuild_deprecate( " cmake_add_c_flags is deprecated, use ecbuild_add_c_flags instead." )
  ecbuild_add_c_flags( ${ARGV} )
endmacro()
