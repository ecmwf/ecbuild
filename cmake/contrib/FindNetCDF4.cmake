# Project uclales
# http://gitorious.org/uclales
# License: Academic Free License v3.0
#
# - Find NETCDF, a library for reading and writing self describing array data.
#
# This module invokes the NETCDF "nc-config" script that is provided by the 
# NetCDF4 package.
#
# The module will optionally accept the COMPONENTS argument.  If no COMPONENTS
# are specified, then the find module will default to finding only the NETCDF C
# library.  If one or more COMPONENTS are specified, the module will attempt to
# find the language bindings for the specified components.  Currently, the only
# valid components are C, CXX, FORTRAN and F90.
#
# On UNIX systems, this module will read the variable NETCDF_USE_STATIC_LIBRARIES
# to determine whether or not to prefer a static link to a dynamic link for NETCDF
# and all of it's dependencies.  To use this feature, make sure that the
# NETCDF_USE_STATIC_LIBRARIES variable is set before the call to find_package.
#
# To provide the module with a hint about where to find your NETCDF installation,
# set the CMake or environment variable NETCDF_ROOT, NETCDF_DIR, NETCDF_PATH or
# NETCDF4_DIR. The Find module will then look in this path when searching for
# NETCDF executables, paths, and libraries.
#
# In addition to finding the includes and libraries required to compile an NETCDF
# client application, this module also makes an effort to find tools that come
# with the NETCDF distribution that may be useful for regression testing.
#
# This module will define the following variables:
#  NETCDF_INCLUDE_DIRS - Location of the NETCDF includes
#  NETCDF_INCLUDE_DIR - Location of the NETCDF includes (deprecated)
#  NETCDF_DEFINITIONS - Required compiler definitions for NETCDF
#  NETCDF_C_LIBRARIES - Required libraries for the NETCDF C bindings.
#  NETCDF_CXX_LIBRARIES - Required libraries for the NETCDF C++ bindings
#  NETCDF_FORTRAN_LIBRARIES - Required libraries for the NETCDF FORTRAN bindings
#  NETCDF_F90_LIBRARIES - Required libraries for the NETCDF FORTRAN 90 bindings
#  NETCDF_LIBRARIES - Required libraries for all requested bindings
#  NETCDF_FOUND - true if NETCDF was found on the system
#  NETCDF_LIBRARY_DIRS - the full set of library directories
#  NETCDF_IS_PARALLEL - Whether or not NETCDF was found with parallel IO support
#                       for version 4 files via a parallel HDF5 library.
#  NETCDF_CONFIG_EXECUTABLE - the path to the NC-CONFIG tool

#=============================================================================
# Copyright 2009 Kitware, Inc.
#
# Distributed under the OSI-approved BSD License (the "License");
# see accompanying file Copyright.txt for details.
#
# This software is distributed WITHOUT ANY WARRANTY; without even the
# implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
# See the License for more information.
#=============================================================================
# (To distribute this file outside of CMake, substitute the full
#  License text for the above reference.)

# This module is maintained by Thijs Heus <thijs.heus@zmaw.de>.

include(SelectLibraryConfigurations)
include(FindPackageHandleStandardArgs)

# List of the valid NETCDF components
set( NETCDF_VALID_COMPONENTS
    FORTRAN
    F90
    CXX
    C
)

# Invoke the NETCDF wrapper compiler.  The compiler return value is stored to the
# return_value argument, the text output is stored to the output variable.
macro( _NETCDF_CONFIG flag output return_value )
    if( NETCDF_CONFIG_EXECUTABLE )
        exec_program( ${NETCDF_CONFIG_EXECUTABLE}
            ARGS ${flag}
            OUTPUT_VARIABLE ${output}
            RETURN_VALUE ${return_value}
        )
        if( ${${return_value}} EQUAL 0 )
            # do nothing
        else()
            message( STATUS
              "Unable to determine ${flag} from NC-CONFIG." )
        endif()
    endif()
endmacro()
#
# try to find the NETCDF wrapper compilers
find_program( NETCDF_CONFIG_EXECUTABLE
    NAMES nc-config
    HINTS ${NETCDF_ROOT} ${NETCDF_DIR} ${NETCDF_PATH} ${NETCDF4_DIR}
          ENV NETCDF_ROOT ENV NETCDF_DIR ENV NETCDF_PATH ENV NETCDF4_DIR
    PATH_SUFFIXES bin Bin
    DOC "NETCDF CONFIG PROGRAM.  Used only to detect NETCDF compile flags." )
mark_as_advanced( NETCDF_CONFIG_EXECUTABLE )
ecbuild_debug("FindNetCDF4: nc-config executable = ${NETCDF_CONFIG_EXECUTABLE}")

#Use nc-config to check for parallel support for v4 files.
set(output "no")
_NETCDF_CONFIG (--has-parallel4 output return) #available with NetCDF>=4.7.0
if(${return} EQUAL 0)
    if(${output} STREQUAL yes)
        set(NETCDF_IS_PARALLEL TRUE)
    else()
        set(NETCDF_IS_PARALLEL FALSE)
    endif()
else()
    set(output "no")
    _NETCDF_CONFIG (--has-parallel output return)
    if(${output} STREQUAL yes)
        #NOTE: With NetCDF<4.7.0 This may be set to true when only v3 parallel support is available.
        #currently there is no way to completely disambiguate v3 and v4 parallel support for <4.7.0
        set(NETCDF_IS_PARALLEL TRUE)
    else()
        set(NETCDF_IS_PARALLEL FALSE)
    endif()
endif()

set(NETCDF_IS_PARALLEL ${NETCDF_IS_PARALLEL} CACHE BOOL
    "NETCDF library compiled with parallel IO support for version 4 files." )


if( NETCDF_INCLUDE_DIRS AND NETCDF_LIBRARIES )
    # Do nothing: we already have NETCDF_INCLUDE_DIRS and NETCDF_LIBRARIES in the
    # cache, it would be a shame to override them
else()
    if( NOT NETCDF_FIND_COMPONENTS )
        set( NETCDF_LANGUAGE_BINDINGS "C" )
    else()
        # add the extra specified components, ensuring that they are valid.
        foreach( component ${NETCDF_FIND_COMPONENTS} )
            list( FIND NETCDF_VALID_COMPONENTS ${component} component_location )
            if( ${component_location} EQUAL -1 )
                message( FATAL_ERROR
                    "\"${component}\" is not a valid NETCDF component." )
            else()
                list( APPEND NETCDF_LANGUAGE_BINDINGS ${component} )
            endif()
        endforeach()
    endif()

    set( NETCDF_REQUIRED netcdf.h netcdfcpp.h netcdf.mod typesizes.mod netcdf netcdff netcdf_c++ netcdf_c++4)

    foreach( LANGUAGE ${NETCDF_LANGUAGE_BINDINGS} )
        ecbuild_debug("FindNetCDF4: looking for ${LANGUAGE} language bindings")

        set( NETCDF_${LANGUAGE}_FOUND 1 ) # disable this in following if necessary

        # find the NETCDF includes
        set(output "no")
        if( ${LANGUAGE} STREQUAL C )
          _NETCDF_CONFIG (--cflags output return)
        elseif( ${LANGUAGE} STREQUAL CXX )
          _NETCDF_CONFIG (--cxx4flags output return)
        elseif( ${LANGUAGE} STREQUAL FORTRAN OR ${LANGUAGE} STREQUAL F90 )
          _NETCDF_CONFIG (--fflags output return)
        endif()
        if (${output} STREQUAL no)
          message( STATUS "NETCDF_INCLUDE_DIRS is not found for NetCDF component ${LANGUAGE}." )
        else()
          string(REGEX MATCHALL "-I[^ ]*" _INCLUDE_DIRS_ALL "${output}")
          set (NETCDF_${LANGUAGE}_INCLUDE_DIRS)
          foreach (incdir ${_INCLUDE_DIRS_ALL})
            string (REPLACE "-I" "" _tmp ${incdir})
            string (STRIP ${_tmp} _tmp)
            list (APPEND NETCDF_${LANGUAGE}_INCLUDE_DIRS ${_tmp})
          endforeach()
          list( REMOVE_DUPLICATES NETCDF_${LANGUAGE}_INCLUDE_DIRS )
          list( APPEND NETCDF_INCLUDE_DIRS ${NETCDF_${LANGUAGE}_INCLUDE_DIRS} )
        endif()

        # find the NETCDF libraries
        set(output "no")
        if( ${LANGUAGE} STREQUAL C )
          _NETCDF_CONFIG (--libs output return)
        elseif( ${LANGUAGE} STREQUAL CXX )
          _NETCDF_CONFIG (--cxx4libs output return)
        elseif( ${LANGUAGE} STREQUAL FORTRAN OR ${LANGUAGE} STREQUAL F90 )
          _NETCDF_CONFIG (--flibs output return)
        endif()
        if (${output} STREQUAL no)
          message( STATUS "NETCDF_LIBRARIES is not found for NetCDF component ${LANGUAGE}." )
        else()
          string(REGEX MATCHALL "-L[^ ]*" _LIBRARY_DIRS_ALL "${output}")
          set (NETCDF_${LANGUAGE}_LIBRARY_DIRS)
          foreach (libdir ${_LIBRARY_DIRS_ALL})
            string (REPLACE "-L" "" _tmp ${libdir})
            string (STRIP ${_tmp} _tmp)
            list (APPEND NETCDF_${LANGUAGE}_LIBRARY_DIRS ${_tmp})
          endforeach()
          list( REMOVE_DUPLICATES NETCDF_${LANGUAGE}_LIBRARY_DIRS )
          string(REGEX MATCHALL " -l[^ ]*" _LIBRARY_NAMES_ALL "${output}")
          set (NETCDF_${LANGUAGE}_LIBRARY_NAMES)
          foreach (lib ${_LIBRARY_NAMES_ALL})
            string (REPLACE "-l" "" _tmp ${lib})
            string (STRIP ${_tmp} _tmp)
            list (APPEND NETCDF_${LANGUAGE}_LIBRARY_NAMES ${_tmp})
          endforeach()
          list( REMOVE_DUPLICATES NETCDF_${LANGUAGE}_LIBRARY_NAMES )
          foreach( LIB ${NETCDF_${LANGUAGE}_LIBRARY_NAMES} )
            if( UNIX AND NETCDF_USE_STATIC_LIBRARIES )
                # According to bug 1643 on the CMake bug tracker, this is the
                # preferred method for searching for a static library.
                # See http://www.cmake.org/Bug/view.php?id=1643.  We search
                # first for the full static library name, but fall back to a
                # generic search on the name if the static search fails.
                set( THIS_LIBRARY_SEARCH_DEBUG lib${LIB}d.a ${LIB}d )
                set( THIS_LIBRARY_SEARCH_RELEASE lib${LIB}.a ${LIB} )
            else()
                set( THIS_LIBRARY_SEARCH_DEBUG ${LIB}d )
                set( THIS_LIBRARY_SEARCH_RELEASE ${LIB} )
            endif()
            find_library( NETCDF_${LIB}_LIBRARY_DEBUG
                NAMES ${THIS_LIBRARY_SEARCH_DEBUG}
                HINTS ${NETCDF_${LANGUAGE}_LIBRARY_DIRS})
            find_library( NETCDF_${LIB}_LIBRARY_RELEASE
                NAMES ${THIS_LIBRARY_SEARCH_RELEASE}
                HINTS ${NETCDF_${LANGUAGE}_LIBRARY_DIRS})
            select_library_configurations( NETCDF_${LIB} )
            # even though we adjusted the individual library names in
            # select_library_configurations, we still need to distinguish
            # between debug and release variants because NETCDF_LIBRARIES will
            # need to specify different lists for debug and optimized builds.
            # We can't just use the NETCDF_${LIB}_LIBRARY variable (which was set
            # up by the selection macro above) because it may specify debug and
            # optimized variants for a particular library, but a list of
            # libraries is allowed to specify debug and optimized only once.
            if (NETCDF_${LIB}_LIBRARY_RELEASE)
              list( APPEND NETCDF_LIBRARIES_RELEASE ${NETCDF_${LIB}_LIBRARY_RELEASE} )
              list( APPEND NETCDF_${LANGUAGE}_LIBRARIES_RELEASE ${NETCDF_${LIB}_LIBRARY_RELEASE} )
            endif()
            if (NETCDF_${LIB}_LIBRARY_DEBUG)
              list( APPEND NETCDF_LIBRARIES_DEBUG ${NETCDF_${LIB}_LIBRARY_DEBUG} )
              list( APPEND NETCDF_${LANGUAGE}_LIBRARIES_DEBUG ${NETCDF_${LIB}_LIBRARY_DEBUG} )
            endif()
            if ( NETCDF_${LIB}_LIBRARY_RELEASE OR NETCDF_${LIB}_LIBRARY_DEBUG )
            else()
              list( FIND NETCDF_REQUIRED ${LIB} location )
              if( ${location} EQUAL -1 )
              else()
                if(NETCDF_FIND_REQUIRED)
                  message( SEND_ERROR "\"${LIB}\" is not found for NetCDF component ${LANGUAGE}." )
                elseif( NOT NETCDF_FIND_QUIETLY )
                  message( STATUS "\"${LIB}\" is not found for NetCDF component ${LANGUAGE}." )
                else()
                  set( NETCDF_${LANGUAGE}_FOUND 0 )
                endif()
             endif()
            endif()
          endforeach()
        endif()
        list( APPEND NETCDF_LIBRARY_DIRS ${NETCDF_${LANGUAGE}_LIBRARY_DIRS} )

        # Append the libraries for this language binding to the list of all
        # required libraries.

        if( NETCDF_${LANGUAGE}_FOUND )
            ecbuild_debug( "FindNetCDF4: ${LANGUAGE} language bindings found" )
            if( CMAKE_CONFIGURATION_TYPES OR CMAKE_BUILD_TYPE )
                list( APPEND NETCDF_${LANGUAGE}_LIBRARIES
                    debug ${NETCDF_${LANGUAGE}_LIBRARIES_DEBUG}
                    optimized ${NETCDF_${LANGUAGE}_LIBRARIES_RELEASE} )
            else()
                list( APPEND NETCDF_${LANGUAGE}_LIBRARIES
                    ${NETCDF_${LANGUAGE}_LIBRARIES_RELEASE} )
            endif()
        endif()
        # ecbuild_debug_var( NETCDF_${LANGUAGE}_LIBRARIES )
        list( APPEND NETCDF_FOUND_REQUIRED_VARS NETCDF_${LANGUAGE}_FOUND )
    endforeach()

    # We may have picked up some duplicates in various lists during the above
    # process for the language bindings (both the C and C++ bindings depend on
    # libz for example).  Remove the duplicates.
   if( NETCDF_INCLUDE_DIRS )
       list( REMOVE_DUPLICATES NETCDF_INCLUDE_DIRS )
   endif()
   if( NETCDF_LIBRARIES_DEBUG )
       list( REVERSE NETCDF_LIBRARIES_DEBUG )
       list( REMOVE_DUPLICATES NETCDF_LIBRARIES_DEBUG )
       list( REVERSE NETCDF_LIBRARIES_DEBUG )
   endif()
   if( NETCDF_LIBRARIES_RELEASE )
       list( REVERSE NETCDF_LIBRARIES_RELEASE )
       list( REMOVE_DUPLICATES NETCDF_LIBRARIES_RELEASE )
       list( REVERSE NETCDF_LIBRARIES_RELEASE )
   endif()
   if( NETCDF_LIBRARY_DIRS )
       list( REMOVE_DUPLICATES NETCDF_LIBRARY_DIRS )
   endif()

    # Construct the complete list of NETCDF libraries with debug and optimized
    # variants when the generator supports them.
    if( CMAKE_CONFIGURATION_TYPES OR CMAKE_BUILD_TYPE )
        if( NOT NETCDF_LIBRARIES_DEBUG )
          set( NETCDF_LIBRARIES_DEBUG ${NETCDF_LIBRARIES_RELEASE} )
        endif()
        set( NETCDF_LIBRARIES
            debug ${NETCDF_LIBRARIES_DEBUG}
            optimized ${NETCDF_LIBRARIES_RELEASE} )
    else()
        set( NETCDF_LIBRARIES ${NETCDF_LIBRARIES_RELEASE} )
    endif()

endif()

set( NETCDF4_FIND_QUIETLY ${NETCDF_FIND_QUIETLY} )
set( NETCDF4_FIND_REQUIRED ${NETCDF_FIND_REQUIRED} )
# handle the QUIET and REQUIRED arguments and set NETCDF4_FOUND to TRUE
# if all listed variables are valid
# Note: capitalisation of the package name must be the same as in the file name
find_package_handle_standard_args( NetCDF4 DEFAULT_MSG
    ${NETCDF_FOUND_REQUIRED_VARS}
    NETCDF_LIBRARIES
    NETCDF_INCLUDE_DIRS
)

mark_as_advanced(
    NETCDF_INCLUDE_DIRS
    NETCDF_LIBRARIES
    NETCDF_LIBRARY_DIRS
)

set( NETCDF_FOUND  ${NETCDF4_FOUND} )
set( NetCDF_FOUND  ${NETCDF4_FOUND} )
set( NetCDF4_FOUND ${NETCDF4_FOUND} )

# For backwards compatibility we set NETCDF_INCLUDE_DIR to the value of
# NETCDF_INCLUDE_DIRS
set( NETCDF_INCLUDE_DIR "${NETCDF_INCLUDE_DIRS}" )

