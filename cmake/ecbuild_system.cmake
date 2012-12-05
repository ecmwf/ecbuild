# (C) Copyright 1996-2012 ECMWF.
#
# This software is licensed under the terms of the Apache Licence Version 2.0
# which can be obtained at http://www.apache.org/licenses/LICENSE-2.0.
# In applying this licence, ECMWF does not waive the privileges and immunities
# granted to it by virtue of its status as an intergovernmental organisation nor
# does it submit to any jurisdiction.

############################################################################################
# disallow in-source build

if("${CMAKE_SOURCE_DIR}" STREQUAL "${CMAKE_BINARY_DIR}")
  message(FATAL_ERROR
    "${PROJECT_NAME} requires an out of source build.\n
    Please create a separate build directory and run 'cmake path/to/project [options]' from there.")
endif()


############################################################################################
# language support

    # need C enabled because we use it to detect some system stuff
    enable_language( C )

###############################################################################
# include our cmake macros, but only do so if this is the top project
if( ${PROJECT_NAME} STREQUAL ${CMAKE_PROJECT_NAME} )

    set( ECBUILD_PROJECTS "" CACHE INTERNAL "list of ecbuild (sub)projects" )

    # get directory where this file is,
    # but without using the var CMAKE_CURRENT_LIST_DIR (only >=2.8.3)
    get_filename_component( buildsys_dir ${CMAKE_CURRENT_LIST_FILE} PATH )

    # add backward support from 2.8 to 2.6
    if( ${CMAKE_VERSION} VERSION_LESS "2.8" )
        set(CMAKE_MODULE_PATH "${buildsys_dir}/2.8" ${CMAKE_MODULE_PATH} )
    endif()

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

    # include(CMakePrintSystemInformation)

    include(TestBigEndian)

    if( "${CMAKE_VERSION}" VERSION_LESS "2.8.4" )
        include( ${buildsys_dir}/2.8/CMakeParseArguments.cmake )
    else()
        include(CMakeParseArguments)
    endif()

    if( "${CMAKE_VERSION}" VERSION_LESS "2.8.6" )
        include( ${buildsys_dir}/2.8/CMakePushCheckState.cmake )
    else()
        include(CMakePushCheckState)
    endif()

    ############################################################################################
    # add our macros

    # define the script to build the persistent class information
    set( sg_perl "${buildsys_dir}/sg.pl" CACHE INTERNAL "perl script to generate persistent objects" )

    include( ecbuild_debug_var )

    include( ecbuild_check_c_source )
    if( CMAKE_CXX_COMPILER_LOADED )
        include( ecbuild_check_cxx_source )
    endif()

    include( ecbuild_get_date )
    include( ecbuild_add_persistent )
    include( ecbuild_generate_yy )
    include( ecbuild_generate_rpc )
    include( ecbuild_add_subproject )
    include( ecbuild_add_library )
    include( ecbuild_add_executable )
    include( ecbuild_add_test )
    include( ecbuild_add_resources )
    include( ecbuild_project_files )
    include( ecbuild_declare_project )
    include( ecbuild_install_package )
    include( ecbuild_separate_sources )
    include( ecbuild_use_package )
    include( ecbuild_print_summary )
    include( ecbuild_warn_unused_files )
    include( ecbuild_find_python )
    include( ecbuild_enable_fortran )

    ############################################################################################
    # kickstart the build system

    include( ecbuild_define_options )  # define build options
    include( ecbuild_find_packages )   # find packages we depend on
    include( ecbuild_check_os )        # check for os characteristics
    include( ecbuild_check_functions ) # check for available functions
    include( ecbuild_define_paths )    # define installation paths
    include( ecbuild_links_target )    # define the links target

    ############################################################################################
    # define the build timestamp

    if( NOT DEFINED EC_BUILD_TIMESTAMP )
        ecbuild_get_timestamp( EC_BUILD_TIMESTAMP )
        set( EC_BUILD_TIMESTAMP  "${EC_BUILD_TIMESTAMP}" CACHE INTERNAL "Build timestamp" )
    endif()

    ############################################################################################
    # generate the configuration headers here, so external projects also get them

    configure_file( ${buildsys_dir}/ecbuild_config.h.in     ${CMAKE_BINARY_DIR}/ecbuild_config.h   )
    configure_file( ${buildsys_dir}/ecbuild_platform.h.in   ${CMAKE_BINARY_DIR}/ecbuild_platform.h )

    include_directories( ${CMAKE_BINARY_DIR} )

    install( FILES ${CMAKE_BINARY_DIR}/ecbuild_config.h
                   ${CMAKE_BINARY_DIR}/ecbuild_platform.h
             DESTINATION include/${PROJECT_NAME} )

endif()

