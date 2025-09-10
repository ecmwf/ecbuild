# (C) Copyright 2011- ECMWF.
#
# This software is licensed under the terms of the Apache Licence Version 2.0
# which can be obtained at http://www.apache.org/licenses/LICENSE-2.0.
# In applying this licence, ECMWF does not waive the privileges and immunities
# granted to it by virtue of its status as an intergovernmental organisation nor
# does it submit to any jurisdiction.

##############################################################################
#.rst:
#
# FindFFTW
# ========
#
# Find the FFTW library. ::
#
#   find_package(FFTW [REQUIRED] [QUIET]
#                [COMPONENTS [single] [double] [long_double] [quad]])
#
# By default, search for the double precision library ``fftw3``
#
# Search procedure
# ----------------
#
# * FFTW_LIBRARIES and FFTW_INCLUDE_DIRS set by user
#   
#   * Nothing is searched and these variables are used instead
#
# * Find MKL implementation via FFTW_ENABLE_MKL
#
#   * If FFTW_ENABLE_MKL is explicitly set to ON, only MKL is considered
#   * If FFTW_ENABLE_MKL is explicitly set to OFF, MKL will not be considered
#   * If FFTW_ENABLE_MKL is undefined, MKL is preferred unless ENABLE_MKL is explicitly set to OFF
#   * Note: MKLROOT environment variable helps to detect MKL (See FindMKL.cmake)
#
# * Find ARMPL or NVPL implementations, via FFTW_ENABLE_ARMPL or FFTW_ENABLE_NVPL, with behaviour as for MKL
#
# * Find official FFTW implementation
#
#   * FFTW_ROOT variable / environment variable helps to detect FFTW
#
# Components
# ----------
#
# If a different version or multiple versions of the library are required,
# these need to be specified as ``COMPONENTS``. Note that double must be given
# explicitly if any ``COMPONENTS`` are specified.
#
# The libraries corresponding to each of the ``COMPONENTS`` are:
#
# :single:      ``FFTW::fftw3f``
# :double:      ``FFTW::fftw3``
# :long_double: ``FFTW::fftw3l``
# :quad:        ``FFTW::fftw3q``
#
# Output variables
# ----------------
#
# The following CMake variables are set on completion:
#
# :FFTW_FOUND:            true if FFTW is found on the system
# :FFTW_LIBRARIES:        full paths to requested FFTW libraries
# :FFTW_INCLUDE_DIRS:     FFTW include directory
#
# Input variables
# ---------------
#
# The following CMake variables are checked by the function:
#
# :FFTW_USE_STATIC_LIBS:  if true, only static libraries are found
# :FFTW_ROOT:             if set, this path is exclusively searched
# :FFTW_DIR:              equivalent to FFTW_ROOT (deprecated)
# :FFTW_PATH:             equivalent to FFTW_ROOT (deprecated)
# :FFTW_LIBRARIES:        User overriden FFTW libraries
# :FFTW_INCLUDE_DIRS:     User overriden FFTW includes directories
# :FFTW_ENABLE_MKL:       User requests use of MKL implementation
# :FFTW_ENABLE_ARMPL:     User requests use of ARMPL implementation
# :FFTW_ENABLE_NVPL:      User requests use of NVPL implementation
#
##############################################################################

list( APPEND _possible_components double single long_double quad )

if( NOT FFTW_FIND_COMPONENTS )
  set( FFTW_FIND_COMPONENTS double )
endif()

set( FFTW_double_LIBRARY_NAME fftw3 )
set( FFTW_single_LIBRARY_NAME fftw3f )
set( FFTW_long_double_LIBRARY_NAME fftw3l )
set( FFTW_quad_LIBRARY_NAME fftw3q )

macro( FFTW_CHECK_ALL_COMPONENTS )
    set( FFTW_FOUND_ALL_COMPONENTS TRUE )
    foreach( _component ${FFTW_FIND_COMPONENTS} )
        if( NOT FFTW_${_component}_FOUND )
            set( FFTW_FOUND_ALL_COMPONENTS false )
        endif()
    endforeach()
endmacro()

# Command line override
foreach( _component ${FFTW_FIND_COMPONENTS} )
    if( NOT FFTW_${_component}_LIBRARIES AND FFTW_LIBRARIES )
        set( FFTW_${_component}_LIBRARIES ${FFTW_LIBRARIES} )
    endif()
    if( FFTW_${_component}_LIBRARIES )
        set( FFTW_${_component}_FOUND TRUE )
    endif()
endforeach()

### Check MKL
FFTW_CHECK_ALL_COMPONENTS()
if( NOT FFTW_FOUND_ALL_COMPONENTS )

    if( NOT DEFINED FFTW_ENABLE_MKL AND NOT DEFINED ENABLE_MKL )
        set( FFTW_ENABLE_MKL ON )
        set( FFTW_FindMKL_OPTIONS QUIET )
    elseif( FFTW_ENABLE_MKL )
        set( FFTW_MKL_REQUIRED TRUE )
    elseif( ENABLE_MKL AND NOT DEFINED FFTW_ENABLE_MKL )
        set( FFTW_ENABLE_MKL ON )
    endif()

    if( FFTW_ENABLE_MKL )
        if( NOT MKL_FOUND )
            find_package( MKL ${FFTW_FindMKL_OPTIONS} )
        endif()
        if( MKL_FOUND )
            if( NOT FFTW_INCLUDE_DIRS )
                set( FFTW_INCLUDE_DIRS ${MKL_INCLUDE_DIRS}/fftw )
            endif()
            if( NOT FFTW_LIBRARIES )
                set( FFTW_LIBRARIES ${MKL_LIBRARIES} )
            endif()

            foreach( _component ${FFTW_FIND_COMPONENTS} )
                set( FFTW_${_component}_FOUND TRUE )
                set( FFTW_${_component}_LIBRARIES ${MKL_LIBRARIES} )
            endforeach()
        else()
            if( FFTW_MKL_REQUIRED )
                if( FFTW_FIND_REQUIRED )
                    message(CRITICAL "FindFFTW: MKL required, but MKL was not found" )
                else()
                    if( NOT FFTW_MKL_FIND_QUIETLY )
                        message(STATUS "FindFFTW: MKL required, but MKL was not found" )
                    endif()
                    set( FFTW_FOUND FALSE )
                    return()
                endif()
            endif()
        endif()
    endif()
endif()

### Check ARMPL
FFTW_CHECK_ALL_COMPONENTS()
if( NOT FFTW_FOUND_ALL_COMPONENTS )

    if( NOT DEFINED FFTW_ENABLE_ARMPL AND NOT DEFINED ENABLE_ARMPL )
	set( FFTW_ENABLE_ARMPL ON )
	set( FFTW_FindARMPL_OPTIONS QUIET )
    elseif( FFTW_ENABLE_ARMPL )
	set( FFTW_ARMPL_REQUIRED TRUE )
    elseif( ENABLE_ARMPL AND NOT DEFINED FFTW_ENABLE_ARMPL )
	set( FFTW_ENABLE_ARMPL ON )
    endif()

    if( FFTW_ENABLE_ARMPL )
	if( NOT ARMPL_FOUND )
	    find_package( ARMPL ${FFTW_FindARMPL_OPTIONS} )
        endif()
	if( ARMPL_FOUND )
            if( NOT FFTW_INCLUDE_DIRS )
		set( FFTW_INCLUDE_DIRS ${ARMPL_INCLUDE_DIRS} )
            endif()
            if( NOT FFTW_LIBRARIES )
		set( FFTW_LIBRARIES ${ARMPL_LIBRARIES} )
            endif()

            foreach( _component ${FFTW_FIND_COMPONENTS} )
                set( FFTW_${_component}_FOUND TRUE )
		set( FFTW_${_component}_LIBRARIES ${ARMPL_LIBRARIES} )
            endforeach()
        else()
	    if( FFTW_ARMPL_REQUIRED )
                if( FFTW_FIND_REQUIRED )
		    message(CRITICAL "FindFFTW: ARMPL required, but was not found" )
                else()
		    if( NOT FFTW_ARMPL_FIND_QUIETLY )
			message(STATUS "FindFFTW: ARMPL required, but was not found" )
                    endif()
                    set( FFTW_FOUND FALSE )
                    return()
                endif()
            endif()
        endif()
    endif()
endif()

### Check NVPL
FFTW_CHECK_ALL_COMPONENTS()
if( NOT FFTW_FOUND_ALL_COMPONENTS )

    if( NOT DEFINED FFTW_ENABLE_NVPL AND NOT DEFINED ENABLE_NVPL )
	set( FFTW_ENABLE_NVPL ON )
	set( FFTW_FindNVPL_OPTIONS QUIET )
    elseif( FFTW_ENABLE_NVPL )
	set( FFTW_NVPL_REQUIRED TRUE )
    elseif( ENABLE_NVPL AND NOT DEFINED FFTW_ENABLE_NVPL )
	set( FFTW_ENABLE_NVPL ON )
    endif()

    if( FFTW_ENABLE_NVPL )
	if( NOT NVPL_FOUND )
	    find_package( NVPL ${FFTW_FindNVPL_OPTIONS} )
        endif()
	if( NVPL_FOUND )
            if( NOT FFTW_INCLUDE_DIRS )
		set( FFTW_INCLUDE_DIRS ${NVPL_INCLUDE_DIRS} )
            endif()
            if( NOT FFTW_LIBRARIES )
		set( FFTW_LIBRARIES ${NVPL_LIBRARIES} )
            endif()

            foreach( _component ${FFTW_FIND_COMPONENTS} )
                set( FFTW_${_component}_FOUND TRUE )
		set( FFTW_${_component}_LIBRARIES ${NVPL_LIBRARIES} )
            endforeach()
        else()
	    if( FFTW_NVPL_REQUIRED )
                if( FFTW_FIND_REQUIRED )
			message(CRITICAL "FindFFTW: NVPL required, but NVPL was not found" )
                else()
		    if( NOT FFTW_NVPL_FIND_QUIETLY )
			    message(STATUS "FindFFTW: NVPL required, but NVPL was not found" )
                    endif()
                    set( FFTW_FOUND FALSE )
                    return()
                endif()
            endif()
        endif()
    endif()
endif()

### Standard FFTW
if( (NOT FFTW_ROOT) AND EXISTS $ENV{FFTW_ROOT} )
    set( FFTW_ROOT $ENV{FFTW_ROOT} )
endif()
if( (NOT FFTW_ROOT) AND FFTW_DIR )
    set( FFTW_ROOT ${FFTW_DIR} )
endif()
if( (NOT FFTW_ROOT) AND EXISTS $ENV{FFTW_DIR} )
    set( FFTW_ROOT $ENV{FFTW_DIR} )
endif()
if( (NOT FFTW_ROOT) AND FFTWDIR )
    set( FFTW_ROOT ${FFTWDIR} )
endif()
if( (NOT FFTW_ROOT) AND EXISTS $ENV{FFTWDIR} )
    set( FFTW_ROOT $ENV{FFTWDIR} )
endif()
if( (NOT FFTW_ROOT) AND FFTW_PATH )
    set( FFTW_ROOT ${FFTW_PATH} )
endif()
if( (NOT FFTW_ROOT) AND EXISTS $ENV{FFTW_PATH})
    set( FFTW_ROOT $ENV{FFTW_PATH} )
endif()

if( FFTW_ROOT ) # On cc[a|b|t] FFTW_DIR is set to the lib directory :(
    get_filename_component(_dirname ${FFTW_ROOT} NAME)
    if( _dirname MATCHES "lib" )
        set( FFTW_ROOT "${FFTW_ROOT}/.." )
    endif()
endif()

if( NOT FFTW_ROOT )
    # Check if we can use PkgConfig
    find_package(PkgConfig)

    #Determine from PKG
    if( PKG_CONFIG_FOUND AND NOT FFTW_ROOT )
        pkg_check_modules( PKG_FFTW QUIET "fftw3" )
    endif()
endif()

#Check whether to search static or dynamic libs
set( CMAKE_FIND_LIBRARY_SUFFIXES_SAV ${CMAKE_FIND_LIBRARY_SUFFIXES} )

if( ${FFTW_USE_STATIC_LIBS} )
    set( CMAKE_FIND_LIBRARY_SUFFIXES ${CMAKE_STATIC_LIBRARY_SUFFIX} )
else()
    set( CMAKE_FIND_LIBRARY_SUFFIXES ${CMAKE_SHARED_LIBRARY_SUFFIX} )
endif()


if( FFTW_ROOT )
    set( _default_paths NO_DEFAULT_PATH )
    set( _lib_paths ${FFTW_ROOT} )
    set( _include_paths ${FFTW_ROOT} )
else()
    set( _lib_paths ${PKG_FFTW_LIBRARY_DIRS} ${LIB_INSTALL_DIR} )
    set( _include_paths ${PKG_FFTW_INCLUDE_DIRS} ${INCLUDE_INSTALL_DIR} )
endif()

# find includes
if( NOT FFTW_INCLUDE_DIRS )
    find_path(
        FFTW_INCLUDE_DIR
        NAMES "fftw3.h"
        PATHS ${_include_paths}
        PATH_SUFFIXES "include"
        ${_default_paths}
        )
    if( NOT FFTW_INCLUDE_DIR )
        if( NOT FFTW_FIND_QUIETLY OR FFTW_FIND_REQUIRED )
            message( STATUS "FindFFTW: fftw include headers not found")
        endif()
    endif()

    set( FFTW_INCLUDE_DIRS ${FFTW_INCLUDE_DIR} )
endif()

# find libs
foreach( _component ${FFTW_FIND_COMPONENTS} )
    if( NOT FFTW_${_component}_LIBRARIES )
        find_library(
            FFTW_${_component}_LIB
            NAMES ${FFTW_${_component}_LIBRARY_NAME}
            PATHS ${_lib_paths}
            PATH_SUFFIXES "lib" "lib64"
            ${_default_paths}
            )
        set( FFTW_${_component}_LIBRARIES ${FFTW_${_component}_LIB} )
        if( FFTW_${_component}_LIBRARIES )
            set( FFTW_${_component}_FOUND TRUE )
        else()
            if( NOT FFTW_FIND_QUIETLY OR FFTW_FIND_REQUIRED )
                message(STATUS "FindFFTW: ${_component} precision required, but ${FFTW_${_component}_LIBRARY_NAME} was not found")
            endif()
            set( FFTW_${_component}_FOUND FALSE )
        endif()
    endif()
endforeach()

# Assemble FFTW_LIBRARIES
if( NOT FFTW_LIBRARIES )
    foreach( _component ${FFTW_FIND_COMPONENTS} )
        list( APPEND FFTW_LIBRARIES ${FFTW_${_component}_LIBRARIES} )
    endforeach()
    list( REMOVE_DUPLICATES FFTW_LIBRARIES )
endif()

# FFTW CREATE_INTERFACE_TARGETS
foreach( _component ${FFTW_FIND_COMPONENTS} )
    set( _target FFTW::${FFTW_${_component}_LIBRARY_NAME} )

    if( FFTW_${_component}_FOUND AND NOT TARGET ${_target} )
        add_library( ${_target} INTERFACE IMPORTED )
        target_link_libraries( ${_target} INTERFACE ${FFTW_${_component}_LIBRARIES} )
        target_include_directories( ${_target} INTERFACE ${FFTW_INCLUDE_DIRS} )
    endif()
endforeach()

if( NOT FFTW_FIND_QUIETLY AND FFTW_LIBRARIES )
  message( STATUS "FFTW targets:" )
  foreach( _component ${FFTW_FIND_COMPONENTS} )
    set( _target FFTW::${FFTW_${_component}_LIBRARY_NAME} )
    message( STATUS "    ${_target} (${_component} precision)  [${FFTW_${_component}_LIBRARIES}]")
  endforeach()
endif()


set( CMAKE_FIND_LIBRARY_SUFFIXES ${CMAKE_FIND_LIBRARY_SUFFIXES_SAV} )

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args( FFTW
                                   REQUIRED_VARS FFTW_INCLUDE_DIRS FFTW_LIBRARIES
                                   HANDLE_COMPONENTS )

set( FFTW_INCLUDES ${FFTW_INCLUDE_DIRS} ) # deprecated
set( FFTW_LIB ${FFTW_double_LIBRARIES} ) # deprecated
mark_as_advanced(FFTW_INCLUDE_DIRS FFTW_LIBRARIES FFTW_LIB)
