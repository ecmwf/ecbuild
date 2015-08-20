# (C) Copyright 1996-2014 ECMWF.
#
# This software is licensed under the terms of the Apache Licence Version 2.0
# which can be obtained at http://www.apache.org/licenses/LICENSE-2.0.
# In applying this licence, ECMWF does not waive the privileges and immunities
# granted to it by virtue of its status as an intergovernmental organisation nor
# does it submit to any jurisdiction.

###############################################################################
#
# macro for adding search paths to CMAKE_PREFIX_PATH
# for example the ECMWF /usr/local/apps paths
#
# usage: ecbuild_add_extra_search_paths( netcdf4 )

function( ecbuild_add_extra_search_paths pkg )

  message( DEPRECATION " ecbuild_add_extra_search_paths modifies CMAKE_PREFIX_PATH,"
           " which can affect future package discovery if not undone by the caller."
           " The current CMAKE_PREFIX_PATH is being backed up as _CMAKE_PREFIX_PATH"
           " so it can later be restored." )

  # Back up current CMAKE_PREFIX_PATH so the caller can reset it
  set( _CMAKE_PREFIX_PATH ${CMAKE_PREFIX_PATH} PARENT_SCOPE )

  string( TOUPPER ${pkg} _PKG )

  ecbuild_list_extra_search_paths( ${pkg} CMAKE_PREFIX_PATH )

  # in DEVELOPER_MODE we give priority to projects parallel in the build tree
  # so lets prepend a parallel build tree to the search path if we find it
  if( DEVELOPER_MODE )
    if( EXISTS ${CMAKE_BINARY_DIR}/../${pkg}/${pkg}-config.cmake )
      if( ${_PKG}_PATH )
        ecbuild_debug("ecbuild_add_extra_search_paths(${pkg}): in DEVELOPER_MODE - ${_PKG}_PATH is set to ${${_PKG}_PATH}, not modifying")
      else()
        get_filename_component( _proj_bdir "${CMAKE_BINARY_DIR}/../${pkg}" ABSOLUTE )
        ecbuild_debug("ecbuild_add_extra_search_paths(${pkg}): in DEVELOPER_MODE - setting ${_PKG}_PATH to ${_proj_bdir}")
        set( ${_PKG}_PATH "${_proj_bdir}" PARENT_SCOPE )
      endif()
    endif()
  endif()

  set( CMAKE_PREFIX_PATH ${CMAKE_PREFIX_PATH} PARENT_SCOPE )
  # debug_var( CMAKE_PREFIX_PATH )

endfunction()
