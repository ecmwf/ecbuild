# SPDX-FileCopyrightText: 2011- European Centre for Medium-Range Weather Forecasts (ECMWF)
# SPDX-License-Identifier: Apache-2.0

##############################################################################
#.rst:
#
# ecbuild_add_fortran_flags
# =========================
#
# Add Fortran compiler flags to CMAKE_Fortran_FLAGS only if supported by the
# compiler. ::
#
#   ecbuild_add_fortran_flags( <flag1> [ <flag2> ... ]
#                              [ BUILD <build> ]
#                              [ NAME <name> ]
#                              [ NO_FAIL ]
#                              [ PROJECT ] )
#
# Options
# -------
#
# BUILD : optional
#   add flags to ``CMAKE_Fortran_FLAGS_<build>`` instead of
#   ``CMAKE_Fortran_FLAGS``
#
# NAME : optional
#   name of the check (if omitted, checks are enumerated)
#
# NO_FAIL : optional
#   do not fail if the flag cannot be added
#
# PROJECT : optional
#   add flags to project specific ``${PNAME}_Fortran_FLAGS`` and
#   ``${PNAME}_Fortran_FLAGS_<build>`` instead of the corresponding
#   ``CMAKE_Fortran_FLAGS`` variables.
#
##############################################################################

include( CheckFortranCompilerFlag )

include(ecbuild_add_lang_flags)

macro( ecbuild_add_fortran_flags )
  ecbuild_debug("call ecbuild_add_fortran_flags( ${ARGV} )")
  ecbuild_add_lang_flags( FLAGS ${ARGV} LANG Fortran )
endmacro()

macro( cmake_add_fortran_flags )
  ecbuild_deprecate( " cmake_add_fortran_flags is deprecated, use ecbuild_add_fortran_flags instead." )
  ecbuild_add_fortran_flags( ${ARGV} )
endmacro()
