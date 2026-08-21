# (C) Copyright 2011- ECMWF.
#
# This software is licensed under the terms of the Apache Licence Version 2.0
# which can be obtained at http://www.apache.org/licenses/LICENSE-2.0.
# In applying this licence, ECMWF does not waive the privileges and immunities
# granted to it by virtue of its status as an intergovernmental organisation nor
# does it submit to any jurisdiction.

##############################################################################
#.rst:
#
# ecbuild_find_perl
# =================
#
# Find perl executable and its version. ::
#
#   ecbuild_find_perl( [ REQUIRED ] )
#
# Options
# -------
#
# REQUIRED : optional
#   fail if perl was not found
#
# Output variables
# ----------------
#
# The following CMake variables are set if perl was found:
#
# :PERL_FOUND:          perl was found
# :PERL_EXECUTABLE:     path to the perl executable
# :PERL_VERSION:        perl version
# :PERL_VERSION_STRING: perl version (same as ``PERL_VERSION``)
#
##############################################################################

macro( ecbuild_find_perl )

  # parse parameters

  set( options REQUIRED )
  set( single_value_args )
  set( multi_value_args  )

  cmake_parse_arguments( _p "${options}" "${single_value_args}" "${multi_value_args}"  ${_FIRST_ARG} ${ARGN} )

  if(_p_UNPARSED_ARGUMENTS)
    ecbuild_critical("Unknown keywords given to ecbuild_find_perl(): \"${_p_UNPARSED_ARGUMENTS}\"")
  endif()

  # Probe only once per build tree: PERL_EXECUTABLE is a cache entry, so testing
  # it makes the probe happen once and the results are then published through
  # the cache to every later directory scope.
  if( NOT DEFINED PERL_EXECUTABLE )

    find_package( Perl QUIET )

    # FindPerl already determined the version
    if( NOT PERL_VERSION )
      set( PERL_VERSION "${PERL_VERSION_STRING}" )
    endif()

    set( PERL_FOUND          "${PERL_FOUND}"          CACHE INTERNAL "Perl was found" )
    set( PERL_VERSION        "${PERL_VERSION}"        CACHE INTERNAL "Perl version" )
    set( PERL_VERSION_STRING "${PERL_VERSION_STRING}" CACHE INTERNAL "Perl version" )

    ecbuild_debug("ecbuild_find_perl: found perl version ${PERL_VERSION_STRING} as ${PERL_EXECUTABLE}")

  endif()

  if( NOT PERL_EXECUTABLE AND _p_REQUIRED )
    ecbuild_critical( "Failed to find Perl (REQUIRED)" )
  endif()

endmacro( ecbuild_find_perl )
