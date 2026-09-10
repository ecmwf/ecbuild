# SPDX-FileCopyrightText: 2011- European Centre for Medium-Range Weather Forecasts (ECMWF)
# SPDX-License-Identifier: Apache-2.0

###############################################################################
#
# macro for adding search paths to CMAKE_PREFIX_PATH
# for example the ECMWF /usr/local/apps paths
#
# usage: ecbuild_add_extra_search_paths( netcdf4 )

function( ecbuild_add_extra_search_paths pkg )

  ecbuild_deprecate( " ecbuild_add_extra_search_paths modifies CMAKE_PREFIX_PATH,"
                     " which can affect future package discovery if not undone by the caller."
                     " The current CMAKE_PREFIX_PATH is being backed up as _CMAKE_PREFIX_PATH"
                     " so it can later be restored." )

  # Back up current CMAKE_PREFIX_PATH so the caller can reset it
  set( _CMAKE_PREFIX_PATH ${CMAKE_PREFIX_PATH} PARENT_SCOPE )

  string( TOUPPER ${pkg} _PKG )

  ecbuild_list_extra_search_paths( ${pkg} CMAKE_PREFIX_PATH )

  set( CMAKE_PREFIX_PATH ${CMAKE_PREFIX_PATH} PARENT_SCOPE )
  # ecbuild_debug_var( CMAKE_PREFIX_PATH )

endfunction()
