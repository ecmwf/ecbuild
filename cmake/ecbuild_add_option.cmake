# (C) Copyright 1996-2014 ECMWF.
#
# This software is licensed under the terms of the Apache Licence Version 2.0
# which can be obtained at http://www.apache.org/licenses/LICENSE-2.0.
# In applying this licence, ECMWF does not waive the privileges and immunities
# granted to it by virtue of its status as an intergovernmental organisation nor
# does it submit to any jurisdiction.

##############################################################################
# macro for adding a test
##############################################################################

macro( ecbuild_add_option )

	set( options ADVANCED )
	set( single_value_args FEATURE DEFAULT DESCRIPTION )
	set( multi_value_args  REQUIRED_PACKAGES )

	cmake_parse_arguments( _p "${options}" "${single_value_args}" "${multi_value_args}"  ${_FIRST_ARG} ${ARGN} )

	if( _p_UNPARSED_ARGUMENTS )
	  message(FATAL_ERROR "Unknown keywords given to ecbuild_add_option(): \"${_PAR_UNPARSED_ARGUMENTS}\"")
    endif()

	if( NOT _p_FEATURE  )
	  message(FATAL_ERROR "The call to ecbuild_add_option() doesn't specify the FEATURE.")
    endif()

	if( ENABLE_${_p_FEATURE} MATCHES "[Aa][Uu][Tt][Oo]" )
		set( __user_provided_input 0 )
	else()
		set( __user_provided_input 1 )
	endif()

	if( NOT DEFINED _p_DEFAULT )
		set( _p_DEFAULT AUTO )
	endif()

	option( ENABLE_${_p_FEATURE} "${_p_DESCRIPTION}" ${_p_DEFAULT} )

	add_feature_info( ${_p_FEATURE} ENABLE_${_p_FEATURE} "${_p_DESCRIPTION}")

	if( ${_p_ADVANCED} )
		mark_as_advanced( ENABLE_${_p_FEATURE} )
	endif()

	if( ENABLE_${_p_FEATURE} )

		set( HAVE_${_p_FEATURE} 1 )

		### search for dependent packages

		foreach( pkg ${_p_REQUIRED_PACKAGES} )

			string(REPLACE " " ";" pkglist ${pkg}) # string to list

			list( GET pkglist 0 pkgname )

			if( pkgname STREQUAL "PROJECT" )  # if 1st entry is PROJECT, then we are looking for a ecbuild project
				set( pkgproject 1 )
				list( GET pkglist 1 pkgname )
			else()                            # else 1st entry is package name
				set( pkgproject 0 )
			endif()

#			debug_var( pkg )
#			debug_var( pkglist )
#			debug_var( pkgname )

			string( TOUPPER ${pkgname} pkgUPPER )
			string( TOLOWER ${pkgname} pkgLOWER )

			if( NOT ${pkgUPPER}_FOUND )

				ecbuild_add_extra_search_paths( ${pkgLOWER} ) # adds search paths specific to ECMWF

				if( pkgproject )
					ecbuild_use_package( ${pkglist} )
				else()
					find_package( ${pkglist} )
				endif()

				# append to list of third-party libraries (to be forward to other packages )
				string( TOUPPER ${PROJECT_NAME} PNAME )
				list( APPEND ${PNAME}_TPLS ${pkgname} )

			endif()

			# we have feature iff all required packages were FOUND

			if( NOT ${pkgUPPER_FOUND} )
				message( STATUS "Could not find package $pkg required for feature ${_p_FEATURE}" )
				set( HAVE_${_p_FEATURE} 0 )
				list( APPEND _failed_to_find_packages ${pkgname} )
			endif()

		endforeach()

		# FINAL CHECK

		if( HAVE_${_p_FEATURE} )

			message( STATUS "Feature ${_p_FEATURE} enabled" )

		else()

			if( __user_provided_input ) # user provided input and we cannot satisfy, so fail
				 message( FATAL_ERROR "Feature ${_p_FEATURE} cannot be enabled -- following required packages weren't found: ${_failed_to_find_packages}" )
			else()
				 message( STATUS "Feature ${_p_FEATURE} was not enabled (also not requested) -- following required packages weren't found: ${_failed_to_find_packages}" )
			endif()

		endif()

	else( ENABLE_${_p_FEATURE} )

		set( HAVE_${_p_FEATURE} 0 )

	endif( ENABLE_${_p_FEATURE} )

endmacro( ecbuild_add_option  )
