# (C) Copyright 2011- ECMWF.
#
# This software is licensed under the terms of the Apache Licence Version 2.0
# which can be obtained at http://www.apache.org/licenses/LICENSE-2.0.
# In applying this licence, ECMWF does not waive the privileges and immunities
# granted to it by virtue of its status as an intergovernmental organisation
# nor does it submit to any jurisdiction.

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
#                              [ NO_FAIL ] )
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
##############################################################################

include( CheckFortranCompilerFlag )

include(ecbuild_add_lang_flags)

macro( ecbuild_add_fortran_flags )
    ecbuild_debug("call ecbuild_add_fortran_flags( ${ARGV} )")
    ecbuild_add_lang_flags( ${ARGV} LANG Fortran )
endmacro()

macro( cmake_add_fortran_flags )
  ecbuild_deprecate( " cmake_add_fortran_flags is deprecated, use ecbuild_add_fortran_flags instead." )
  ecbuild_add_fortran_flags( ${ARGV} )
endmacro()
