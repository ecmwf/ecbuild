# (C) Copyright 1996-2012 ECMWF.
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

	string( TOUPPER ${PROJECT_NAME} PNAME )

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

		if( ENABLE_${_p_FEATURE} MATCHES "[Aa][Uu][Tt][Oo]" )
			set( __user_provided_input 0 )
		else()
			set( __user_provided_input 1 )
		endif()

		### search for dependent packages

		foreach( pkg ${_p_REQUIRED_PACKAGES} )

			string( TOUPPER ${pkg} pkgUPPER )
			string( TOLOWER ${pkg} pkgLOWER )

			if( NOT ${pkgUPPER}_FOUND )

				ecbuild_add_extra_search_paths( ${pkgLOWER} ) # adds search paths specific to ECMWF
				find_package( ${pkg} )

				# append to list of third-party libraries (to be forward to other packages
				list( APPEND ${PNAME}_TPLS ${pkg} )

			endif()

			# we have feature iff all required packages were FOUND

			if( NOT ${pkgUPPER_FOUND} )
				set( HAVE_${_p_FEATURE} 0 )
				list( APPEND _failed_to_find_packages ${pkg} )
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

	endif( ENABLE_${_p_FEATURE} )

endmacro( ecbuild_add_option  )
