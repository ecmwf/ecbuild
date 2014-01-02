# (C) Copyright 1996-2012 ECMWF.
#
# This software is licensed under the terms of the Apache Licence Version 2.0
# which can be obtained at http://www.apache.org/licenses/LICENSE-2.0.
# In applying this licence, ECMWF does not waive the privileges and immunities
# granted to it by virtue of its status as an intergovernmental organisation nor
# does it submit to any jurisdiction.

# macro to initialize a project

macro( ecbuild_declare_project )

	string( TOUPPER ${PROJECT_NAME} PNAME )

	# reset the lists of targets (executables, libs, tests & resources)

	set( ${PROJECT_NAME}_ALL_EXES "" CACHE INTERNAL "" )
	set( ${PROJECT_NAME}_ALL_LIBS "" CACHE INTERNAL "" )

	# if git project get its HEAD SHA1
	# leave it here so we may use ${PNAME}_GIT_SHA1 on the version file

	if( EXISTS ${PROJECT_SOURCE_DIR}/.git )
		get_git_head_revision( GIT_REFSPEC ${PNAME}_GIT_SHA1 )
		string( SUBSTRING "${${PNAME}_GIT_SHA1}" 0 7 ${PNAME}_GIT_SHA1_SHORT )
#		debug_var( ${PNAME}_GIT_SHA1 )
#		debug_var( ${PNAME}_GIT_SHA1_SHORT )
	endif()

	# read and parse project version file
	if( EXISTS ${PROJECT_SOURCE_DIR}/VERSION.cmake )
		include( ${PROJECT_SOURCE_DIR}/VERSION.cmake )
	else()
		set( ${PROJECT_NAME}_VERSION_STR "0.0.0" )
	endif()

	string( REPLACE "." " " _version_list ${${PROJECT_NAME}_VERSION_STR} ) # dots to spaces

	separate_arguments( _version_list )

	list( GET _version_list 0 ${PNAME}_MAJOR_VERSION )
	list( GET _version_list 1 ${PNAME}_MINOR_VERSION )
	list( GET _version_list 2 ${PNAME}_PATCH_VERSION )

	# cleanup patch version of any extra qualifiers ( -dev -rc1 ... )

	string( REGEX REPLACE "^([0-9]+).*" "\\1" ${PNAME}_PATCH_VERSION "${${PNAME}_PATCH_VERSION}" )

	set( ${PNAME}_VERSION "${${PNAME}_MAJOR_VERSION}.${${PNAME}_MINOR_VERSION}.${${PNAME}_PATCH_VERSION}" )

	set( ${PNAME}_VERSION_STR "${${PROJECT_NAME}_VERSION_STR}" ) # ignore caps

#    debug_var( ${PNAME}_VERSION )
#    debug_var( ${PNAME}_VERSION_STR )
#    debug_var( ${PNAME}_MAJOR_VERSION )
#    debug_var( ${PNAME}_MINOR_VERSION )
#    debug_var( ${PNAME}_PATCH_VERSION )

	# user defined project-specific installation paths

	set(${PNAME}_INSTALL_LIB_DIR     lib     CACHE PATH "${PNAME} installation directory for libraries")
	set(${PNAME}_INSTALL_BIN_DIR     bin     CACHE PATH "${PNAME} installation directory for executables")

	set(${PNAME}_INSTALL_INCLUDE_DIR include                      CACHE PATH "${PNAME} installation directory for header files")
	set(${PNAME}_INSTALL_DATA_DIR    share/${PROJECT_NAME}        CACHE PATH "${PNAME} installation directory for data files")
	set(${PNAME}_INSTALL_CMAKE_DIR   share/${PROJECT_NAME}/cmake  CACHE PATH "${PNAME} installation directory for CMake files")

	# install dirs local to this project

	set( INSTALL_BIN_DIR     ${${PNAME}_INSTALL_BIN_DIR}     )
	set( INSTALL_LIB_DIR     ${${PNAME}_INSTALL_LIB_DIR}     )
	set( INSTALL_INCLUDE_DIR ${${PNAME}_INSTALL_INCLUDE_DIR} )
	set( INSTALL_DATA_DIR    ${${PNAME}_INSTALL_DATA_DIR}    )
	set( INSTALL_CMAKE_DIR   ${${PNAME}_INSTALL_CMAKE_DIR}   )

	if( ENABLE_RPATHS ) # install with this RPATH
		if( IS_ABSOLUTE ${INSTALL_LIB_DIR} )
			set( CMAKE_INSTALL_RPATH "${INSTALL_LIB_DIR}" )
		else()
			set( CMAKE_INSTALL_RPATH "${CMAKE_INSTALL_PREFIX}/${INSTALL_LIB_DIR}" )
		endif()
	endif()

	# make relative paths absolute  ( needed later on ) and cache them ...
	foreach( p LIB BIN INCLUDE DATA CMAKE )

		set( var INSTALL_${p}_DIR )

		if( NOT IS_ABSOLUTE "${${var}}" )
			set( ${PNAME}_FULL_INSTALL_${p}_DIR "${CMAKE_INSTALL_PREFIX}/${${var}}" CACHE INTERNAL "${PNAME} ${p} full install path" )
		else()
			message( WARNING "Setting an absolute path for ${VAR} in project ${PNAME}, breakes generation of relocatable binary packages (rpm,deb,...)" )
			set( ${PNAME}_FULL_INSTALL_${p}_DIR "${${var}}" CACHE INTERNAL "${PNAME} ${p} full install path" )
		endif()

#        debug_var( ${PNAME}_FULL_INSTALL_${p}_DIR )

	endforeach()

	# print project header

	message( STATUS "---------------------------------------------------------" )

	if( ${PNAME}_GIT_SHA1_SHORT )
		message( STATUS "[${PROJECT_NAME}] (${${PNAME}_VERSION_STR}) [${${PNAME}_GIT_SHA1_SHORT}]" )
	else()
		message( STATUS "[${PROJECT_NAME}] (${${PNAME}_VERSION_STR})" )
	endif()

endmacro( ecbuild_declare_project )

