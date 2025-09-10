# (C) Copyright 2011- ECMWF.
#
# This software is licensed under the terms of the Apache Licence Version 2.0
# which can be obtained at http://www.apache.org/licenses/LICENSE-2.0.
# In applying this licence, ECMWF does not waive the privileges and immunities
# granted to it by virtue of its status as an intergovernmental organisation nor
# does it submit to any jurisdiction.

if( NOT ${PROJECT_NAME}_ECBUILD_SYSTEM_INCLUDED )
set( ${PROJECT_NAME}_ECBUILD_SYSTEM_INCLUDED TRUE )

include( ecbuild )

########################################################################################################
# disallow in-source build
if( EXISTS ${CMAKE_SOURCE_DIR}/CMakeCache.txt ) # check for failed attempts to build within the source tree
    message( FATAL_ERROR "Project ${PROJECT_NAME} contains a CMakeCache.txt inside source tree [${CMAKE_SOURCE_DIR}/CMakeCache.txt].\n Please remove it and
    make sure that source tree is prestine and clean of unintended files, before retrying." )
endif()

get_filename_component(srcdir "${CMAKE_SOURCE_DIR}" REALPATH)
get_filename_component(bindir "${CMAKE_BINARY_DIR}" REALPATH)

if(${srcdir} STREQUAL ${bindir})
    message("######################################################")
    message("You are attempting to build in your source directory (${srcdir}).")
    message("You must run cmake from a different build directory.")
    message("######################################################")
    message( FATAL_ERROR "${PROJECT_NAME} requires an out of source build.\n Please create a separate build directory and run 'cmake path/to/project [options]' from there.")
endif()

########################################################################################################
# ecbuild versioning support

set( ECBUILD_CMAKE_MINIMUM "3.11.0" )
if( ${CMAKE_VERSION} VERSION_LESS ${ECBUILD_CMAKE_MINIMUM} )
    message(FATAL_ERROR "${PROJECT_NAME} requires at least CMake ${ECBUILD_CMAKE_MINIMUM} -- you are using ${CMAKE_COMMAND} [${CMAKE_VERSION}]\n Please, get a newer version of CMake @ www.cmake.org" )
endif()

set( ECBUILD_MACROS_DIR "${CMAKE_CURRENT_LIST_DIR}" CACHE INTERNAL "where ecbuild system is" )

if( NOT ecbuild_VERSION_STR )
  include( ecbuild_parse_version )
  ecbuild_parse_version_file( "${ECBUILD_MACROS_DIR}/VERSION" PREFIX ecbuild )
endif()

# Set policies
if( NOT ( PROJECT_NAME STREQUAL ecbuild ) )
    include( ecbuild_policies NO_POLICY_SCOPE )
endif()

# set capitalised project name

if( ECBUILD_2_COMPAT )
  string( TOUPPER ${PROJECT_NAME} PROJECT_NAME_CAPS )
  string( TOLOWER ${PROJECT_NAME} PROJECT_NAME_LOWCASE )
endif()

########################################################################################################
# include our cmake macros, but only if any parent project is not an ecbuild project

if( NOT ECBUILD_SYSTEM_INITIALISED )

    # hostname of where we build

    site_name( BUILD_SITE )
    mark_as_advanced( BUILD_SITE )
    mark_as_advanced( BUILD_TESTING )

    set( ECBUILD_PROJECTS  "" CACHE INTERNAL "list of ecbuild (sub)projects that use ecbuild" )

    # Include log macros since these are used right away
    include( ecbuild_log )

    # Enable the compatibility layer
    if(ECBUILD_2_COMPAT)
        set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} "${CMAKE_CURRENT_LIST_DIR}/compat" )
        include(ecbuild_compat)

        # Deprecate capitalised project name
        ecbuild_mark_compat(${PROJECT_NAME_CAPS} ${PROJECT_NAME})
        ecbuild_mark_compat(${PROJECT_NAME_LOWCASE} ${PROJECT_NAME})
    endif()

    execute_process( COMMAND env OUTPUT_VARIABLE __env )
    ecbuild_debug( "---------------------------------------------------------" )
    ecbuild_debug( "Environment:" )
    ecbuild_debug( "---------------------------------------------------------\n${__env}" )
    ecbuild_debug( "---------------------------------------------------------" )

    ecbuild_info( "ecbuild   ${ecbuild_VERSION_STR}\t${ECBUILD_MACROS_DIR}" )
    ecbuild_info( "cmake     ${CMAKE_MAJOR_VERSION}.${CMAKE_MINOR_VERSION}.${CMAKE_PATCH_VERSION}\t${CMAKE_COMMAND}" )

    if( CMAKE_TOOLCHAIN_FILE )
      ecbuild_info( "toolchain ${CMAKE_TOOLCHAIN_FILE}" )
    endif()

    if( ECBUILD_CONFIG )
      ecbuild_info( "config    ${ECBUILD_CONFIG}" )
    endif()

    if( ECBUILD_CACHE )
      include( ${ECBUILD_CACHE} )
      ecbuild_info( "cache     ${ECBUILD_CACHE}" )
    endif()

    ecbuild_info( "---------------------------------------------------------" )

    # add extra macros from external contributions
    set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} "${CMAKE_CURRENT_LIST_DIR}/contrib" )

    ############################################################################################
    # define valid build types

    include(ecbuild_define_build_types)

    ############################################################################################
    # define custom properties

    include(ecbuild_define_properties)

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
    include(CMakePushCheckState)

    # include(CMakePrintSystemInformation) # available in cmake 2.8.4

    if( CMAKE_CXX_COMPILER_LOADED )
        include(CheckIncludeFileCXX)
        include(CheckCXXCompilerFlag)
        include(CheckCXXSourceCompiles)
        include(CheckCXXSourceRuns)
    endif()

    if( CMAKE_Fortran_COMPILER_LOADED )
        set( CMAKE_Fortran_MODULE_DIRECTORY  ${CMAKE_BINARY_DIR}/module CACHE PATH "directory for all fortran modules." )
        include(CheckFortranFunctionExists)
        if( CMAKE_C_COMPILER_LOADED AND ENABLE_FORTRAN_C_INTERFACE )
            include(FortranCInterface)
        endif()
        set( EC_HAVE_FORTRAN 1 )
    endif()

    include(FeatureSummary) # support features in cmake

    include(TestBigEndian)

    ############################################################################################
    # add our macros

    include( ecbuild_evaluate_dynamic_condition )
    include( ecbuild_filter_list )

    include( ecbuild_regex_escape )
    include( ecbuild_parse_version )

    include( ecbuild_list_macros )
    include( ecbuild_list_add_pattern )
    include( ecbuild_list_exclude_pattern )

    include( ecbuild_try_run )
    include( ecbuild_check_c_source_return )
    include( ecbuild_check_cxx_source_return )
    include( ecbuild_check_fortran_source_return )

    include( ecbuild_requires_macro_version )
    include( ecbuild_get_date )
    include( ecbuild_add_persistent )
    include( ecbuild_generate_config_headers )
    include( ecbuild_generate_yy )
    include( ecbuild_generate_fortran_interfaces )
    include( ecbuild_echo_targets )
    include( ecbuild_features )
    include( ecbuild_add_option )
    include( ecbuild_add_library )
    include( ecbuild_add_executable )
    include( ecbuild_append_to_rpath )
    include( ecbuild_download_resource )
    include( ecbuild_get_test_data )
    include( ecbuild_check_urls )
    include( ecbuild_add_c_flags )
    include( ecbuild_add_cxx_flags )
    include( ecbuild_get_cxx11_flags )
    include( ecbuild_check_fortran )
    include( ecbuild_add_fortran_flags )
    include( ecbuild_add_test )
    include( ecbuild_add_resources )
    include( ecbuild_get_resources )
    include( ecbuild_dont_pack )
    include( ecbuild_project_files )
    include( ecbuild_declare_project )
    include( ecbuild_generate_project_config )
    include( ecbuild_install_project )
    include( ecbuild_separate_sources )
    include( ecbuild_find_package_search_hints )
    include( ecbuild_find_package )
    include( ecbuild_print_summary )
    include( ecbuild_warn_unused_files )
    include( ecbuild_find_mpi )
    include( ecbuild_find_omp )
    include( ecbuild_find_perl )
    include( ecbuild_find_python )
    include( ecbuild_find_lexyacc )
    include( ecbuild_find_fortranlibs )
    include( ecbuild_git )
    include( ecbuild_enable_fortran )
    include( ecbuild_source_flags )
    include( ecbuild_target_flags )
    include( ecbuild_target_fortran_module_directory )
    include( ecbuild_pkgconfig )
    include( ecbuild_cache )
    include( ecbuild_remove_fortran_flags )
    include( ecbuild_configure_file )

    if( NOT (PROJECT_NAME STREQUAL ecbuild) )
        include( ecbuild_bundle )
    endif()

    include( ${CMAKE_CURRENT_LIST_DIR}/contrib/GetGitRevisionDescription.cmake )

    ############################################################################################
    # kickstart the build system

    if( ECBUILD_CONFIG )
      include( ${ECBUILD_CONFIG} )
    endif()

    ecbuild_prepare_cache()

    if( NOT (PROJECT_NAME STREQUAL ecbuild ) )
        include( ecbuild_define_options )               # define build options
        include( ecbuild_compiler_flags )               # compiler flags
        include( ecbuild_check_compiler )               # check for compiler characteristics
        include( ecbuild_check_os )                     # check for os characteristics
    endif()
    include( ecbuild_define_paths )                 # defines installation paths

    ecbuild_flush_cache()

    ############################################################################################
    # Testing

    include(CTest)                 # add cmake testing support
    enable_testing()

    ############################################################################################
    # define the build timestamp, unless the user provided one via EC_BUILD_TIMESTAMP

    if( NOT DEFINED EC_BUILD_TIMESTAMP )
        ecbuild_get_timestamp( EC_BUILD_TIMESTAMP )
        set( EC_BUILD_TIMESTAMP  "${EC_BUILD_TIMESTAMP}" CACHE INTERNAL "Build timestamp" )
    endif()

    ecbuild_info( "---------------------------------------------------------" )

    set( ECBUILD_SYSTEM_INITIALISED TRUE )

else()

    # Allow subprojects with different compilation flags. This could be done by defining
    #     set( ECBUILD_C_FLAGS_DEBUG "-O0" )
    # or
    #     set( ECBUILD_CONFIG "<subproject-config>.cmake" )
    if( ECBUILD_CONFIG )
        ecbuild_info( "---------------------------------------------------------" )
        ecbuild_info( "config    ${ECBUILD_CONFIG}" )
        include( ${ECBUILD_CONFIG} )
    endif()
    include( ecbuild_compiler_flags )

endif()
endif()
