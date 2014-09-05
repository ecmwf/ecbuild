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

function( ecbuild_list_extra_search_paths pkg var )

	# debug_var( pkg )
	# debug_var( var )

	string( TOUPPER ${pkg} _PKG )

	# PKG_PATH (upper case)

	if( DEFINED ${_PKG}_PATH )
		list( APPEND ${var} ${${_PKG}_PATH} )
	endif()

	# PKG_PATH (lower case)

	if( DEFINED ${pkg}_PATH )
		list( APPEND ${var} ${${pkg}_PATH} )
	endif()

	# fixes BOOST_ROOT taking precedence on the search for location
	if( ${pkg} STREQUAL "boost" )
		if( BOOST_ROOT OR BOOSTROOT OR DEFINED ENV{BOOST_ROOT} OR DEFINED ENV{BOOSTROOT} )
			set( CMAKE_PREFIX_PATH ${BOOST_ROOT} ${BOOSTROOT} $ENV{BOOST_ROOT} $ENV{BOOSTROOT} ${CMAKE_PREFIX_PATH} )
		endif()
	endif()

	# directories under /usr/local/apps/${pkg}

	foreach( _apps /usr/local/apps/${pkg} /usr/local/lib/metaps/lib/${pkg} )

		if( EXISTS ${_apps} )

			 file( GLOB ps ${_apps}/[0-9]* )
			 list( SORT ps )
			 list( REVERSE ps ) # reversing will give us the newest versions first
			 foreach( p ${ps} )
				 if( IS_DIRECTORY ${p} )
					  list( APPEND ${var}  ${p} )
					  if( EXISTS ${p}/LP64 )
						  list( APPEND ${var} ${p}/LP64 )
					  endif()
				 endif()
			 endforeach()

			 foreach( p ${_apps} ${_apps}/current ${_apps}/stable ${_apps}/new ${_apps}/next ${_apps}/prev )
			   if( EXISTS ${p} )
				   list( APPEND ${var} ${p} )
			   endif()
			   if( EXISTS ${p}/LP64 )
				   list( APPEND ${var} ${p}/LP64 )
			   endif()
			 endforeach()

		endif()

	endforeach()

	# sanitize the list

	if( ${var} )
		list( REMOVE_DUPLICATES ${var} )
	endif()

	# define it out of the function

	set( ${var} ${${var}} PARENT_SCOPE )

#	debug_var( ${var} )

endfunction()

