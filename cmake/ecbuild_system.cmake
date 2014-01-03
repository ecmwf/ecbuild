# (C) Copyright 1996-2012 ECMWF.
#
# This software is licensed under the terms of the Apache Licence Version 2.0
# which can be obtained at http://www.apache.org/licenses/LICENSE-2.0.
# In applying this licence, ECMWF does not waive the privileges and immunities
# granted to it by virtue of its status as an intergovernmental organisation nor
# does it submit to any jurisdiction.

############################################################################################
# disallow in-source build

if( EXISTS ${CMAKE_SOURCE_DIR}/CMakeCache.txt ) # check for failed attempts to build within the source tree
   message( FATAL_ERROR "Project ${PROJECT_NAME} contains a CMakeCache.txt inside source tree [${CMAKE_SOURCE_DIR}/CMakeCache.txt].\n Please remove it and
   make sure that source tree is prestine and clean of unintended files, before retrying." )
endif()

if("${CMAKE_SOURCE_DIR}" STREQUAL "${CMAKE_BINARY_DIR}")
	message( FATAL_ERROR "${PROJECT_NAME} requires an out of source build.\n Please create a separate build directory and run 'cmake path/to/project [options]' from there.")
endif()

set( ECBUILD_CMAKE_MINIMUM "2.8.4" )
if( ${CMAKE_VERSION} VERSION_LESS ${ECBUILD_CMAKE_MINIMUM} )
  message(FATAL_ERROR "${PROJECT_NAME} requires at least CMake ${ECBUILD_CMAKE_MINIMUM} -- you are using ${CMAKE_COMMAND} [${CMAKE_VERSION}]\n Please, get a newer version of CMake @ www.cmake.org" )
endif()

set( ECBUILD_MACRO_VERSION "1.3" )

############################################################################################
# language support

# need C enabled because we use it to detect some system stuff
enable_language( C )

###############################################################################
# include our cmake macros, but only do so if this is the top project
if( ${PROJECT_NAME} STREQUAL ${CMAKE_PROJECT_NAME} )

	set( ECBUILD_PROJECTS  "" CACHE INTERNAL "list of ecbuild (sub)projects that use ecbuild" )

	set( ECBUILD_MACROS_DIR "${CMAKE_CURRENT_LIST_DIR}" CACHE INTERNAL "where ecbuild system is" )

	# clear the build dir exported targets file (only on the top project)

	set( TOP_PROJECT_TARGETS_FILE "${PROJECT_BINARY_DIR}/${CMAKE_PROJECT_NAME}-targets.cmake" CACHE INTERNAL "" )
	file( REMOVE ${TOP_PROJECT_TARGETS_FILE} )

	# add backport support for versions up too 2.8.4
	if( ${CMAKE_VERSION} VERSION_LESS "2.8" )
		set(CMAKE_MODULE_PATH "${CMAKE_CURRENT_LIST_DIR}/2.8" ${CMAKE_MODULE_PATH} )
	endif()

	# add extra macros from external contributions
	set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} "${CMAKE_CURRENT_LIST_DIR}/contrib" )

	# would bring FindEigen in, so for the moment keep it out
	# set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} "${CMAKE_CURRENT_LIST_DIR}/contrib/GreatCMakeCookOff" )

	include(CTest)                 # add cmake testing support
	enable_testing()

	option( ENABLE_TESTS "enable the unit tests" ON )

	############################################################################################
	# define valid build types

	include(ecbuild_define_build_types)

	############################################################################################
	# add cmake macros

	include(AddFileDependencies)

	include(CheckTypeSize)
	include(CheckIncludeFile)
	include(CheckIncludeFiles)

	include(CheckFunctionExists)
	include(CheckSymbolExists)

	include(CheckCCompilerFlag)
	include(CheckCSourceCompiles)
	include(CheckCSourceRuns)

	include(CMakeParseArguments)

	# include(CMakePrintSystemInformation) # available in cmake 2.8.4

	if( CMAKE_CXX_COMPILER_LOADED )
		include(CheckIncludeFileCXX)
		include(CheckCXXCompilerFlag)
		include(CheckCXXSourceCompiles)
		include(CheckCXXSourceRuns)
	endif()

	if( CMAKE_Fortran_COMPILER_LOADED )
		include(CheckFortranFunctionExists)
		include(FortranCInterface)
	endif()

	include(TestBigEndian)

	############################################################################################
	# backport of cmake > 2.8.4 functions

	if( "${CMAKE_VERSION}" VERSION_LESS "2.8.6" )
		include( ${CMAKE_CURRENT_LIST_DIR}/2.8/CMakePushCheckState.cmake )
	else()
		include(CMakePushCheckState)
	endif()

	############################################################################################
	# add our macros

	include( ecbuild_debug_var )
	include( ecbuild_list_macros )

	include( ecbuild_check_c_source )

	if( CMAKE_CXX_COMPILER_LOADED )
		include( ecbuild_check_cxx_source )
		include( ecbuild_check_cxx11 )
	endif()

	if( CMAKE_Fortran_COMPILER_LOADED )
		include( ecbuild_check_fortran_source )
	endif()

	include( ecbuild_requires_macro_version )
	include( ecbuild_get_date )
	include( ecbuild_add_persistent )
	include( ecbuild_generate_config_headers )
	include( ecbuild_generate_rpc )
	include( ecbuild_generate_yy )
	include( ecbuild_add_library )
	include( ecbuild_add_executable )
	include( ecbuild_get_test_data )
	include( ecbuild_add_cxx11_flags )
	include( ecbuild_add_test )
	include( ecbuild_add_resources )
	include( ecbuild_get_resources )
	include( ecbuild_project_files )
	include( ecbuild_declare_project )
	include( ecbuild_install_package )
	include( ecbuild_separate_sources )
	include( ecbuild_find_package )
	include( ecbuild_use_package )
	include( ecbuild_list_extra_search_paths )
	include( ecbuild_add_extra_search_paths )
	include( ecbuild_print_summary )
	include( ecbuild_warn_unused_files )
	include( ecbuild_find_mpi )
	include( ecbuild_find_perl )
	include( ecbuild_find_python )
	include( ecbuild_find_lexyacc )
	include( ecbuild_find_fortranlibs )
	include( ecbuild_enable_fortran )

	include( ${CMAKE_CURRENT_LIST_DIR}/contrib/GetGitRevisionDescription.cmake )

	############################################################################################
	# kickstart the build system

	include( ecbuild_define_options )               # define build options
	include( ecbuild_check_compiler )               # check for compiler characteristics
	include( ecbuild_check_os )                     # check for os characteristics
	include( ecbuild_check_functions )              # check for available functions
	include( ecbuild_define_paths )                 # define installation paths
	include( ecbuild_links_target )                 # define the links target

	############################################################################################
	# define the build timestamp

	if( NOT DEFINED EC_BUILD_TIMESTAMP )
		ecbuild_get_timestamp( EC_BUILD_TIMESTAMP )
		set( EC_BUILD_TIMESTAMP  "${EC_BUILD_TIMESTAMP}" CACHE INTERNAL "Build timestamp" )
	endif()

endif()

