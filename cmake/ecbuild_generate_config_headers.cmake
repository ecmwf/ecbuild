# (C) Copyright 1996-2012 ECMWF.
#
# This software is licensed under the terms of the Apache Licence Version 2.0
# which can be obtained at http://www.apache.org/licenses/LICENSE-2.0.
# In applying this licence, ECMWF does not waive the privileges and immunities
# granted to it by virtue of its status as an intergovernmental organisation nor
# does it submit to any jurisdiction.

############################################################################################
# generates the config header fot the project with the system introspection done by CMake

macro( ecbuild_generate_config_headers )

    # parse parameters

    set( options )
	set( single_value_args )
    set( multi_value_args  )

    cmake_parse_arguments( _PAR "${options}" "${single_value_args}" "${multi_value_args}"  ${_FIRST_ARG} ${ARGN} )

    if(_PAR_UNPARSED_ARGUMENTS)
      message(FATAL_ERROR "Unknown keywords given to ecbuild_generate_config_headers(): \"${_PAR_UNPARSED_ARGUMENTS}\"")
    endif()

	# generate list of compiler flags

	get_property( langs GLOBAL PROPERTY ENABLED_LANGUAGES )

	foreach( lang ${langs} )
		set( EC_${lang}_FLAGS "${CMAKE_${lang}_FLAGS} ${CMAKE_${lang}_FLAGS_${CMAKE_BUILD_TYPE_CAPS}}" )
	endforeach()

	configure_file( ${ECBUILD_MACROS_DIR}/ecbuild_config.h.in  ${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}_ecbuild_config.h   )

	# install ecbuild configuration

	install( FILES ${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}_ecbuild_config.h DESTINATION ${INSTALL_INCLUDE_DIR} )

endmacro( ecbuild_generate_config_headers )
