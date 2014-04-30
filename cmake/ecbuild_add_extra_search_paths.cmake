# (C) Copyright 1996-2014 ECMWF.
#
# This software is licensed under the terms of the Apache Licence Version 2.0
# which can be obtained at http://www.apache.org/licenses/LICENSE-2.0.
# In applying this licence, ECMWF does not waive the privileges and immunities
# granted to it by virtue of its status as an intergovernmental organisation nor
# does it submit to any jurisdiction.

############################################################################################
#
# macro for adding search paths to CMAKE_PREFIX_PATH
# for example the ECMWF /usr/local/apps paths
#
# usage: ecbuild_search_paths( netcdf4 )

function( ecbuild_add_extra_search_paths pkg )

	# debug_var( pkg )

	ecbuild_list_extra_search_paths( ${pkg} CMAKE_PREFIX_PATH )

	# debug_var( CMAKE_PREFIX_PATH )

	set( CMAKE_PREFIX_PATH ${CMAKE_PREFIX_PATH} PARENT_SCOPE )

endfunction()

