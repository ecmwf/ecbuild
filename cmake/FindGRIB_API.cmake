# (C) Copyright 1996-2012 ECMWF.
#
# This software is licensed under the terms of the Apache Licence Version 2.0
# which can be obtained at http://www.apache.org/licenses/LICENSE-2.0.
# In applying this licence, ECMWF does not waive the privileges and immunities
# granted to it by virtue of its status as an intergovernmental organisation nor
# does it submit to any jurisdiction.

# - Try to find GRIB_API
# Once done this will define
#  GRIB_API_FOUND - System has GRIB_API
#  GRIB_API_INCLUDE_DIRS - The GRIB_API include directories
#  GRIB_API_LIBRARIES - The libraries needed to use GRIB_API
#  GRIB_API_DEFINITIONS - Compiler switches required for using GRIB_API

option( WITH_GRIB_API "try to find grib_api installation" ON )

# skip if GRIB_API is already found or if has is built inside

if( NOT GRIB_API_FOUND AND WITH_GRIB_API )

    # jpeg support
    
    find_package( JPEG     QUIET ) # grib_api might be a static .a library in which

    if( NOT "$ENV{JASPER_PATH}" STREQUAL "" )
        list( APPEND CMAKE_PREFIX_PATH "$ENV{JASPER_PATH}" )
    endif()
    find_package( Jasper   QUIET ) # case we don't know if which jpeg library was used

    find_package( OpenJPEG QUIET ) # so we try to find all jpeg libs and link to them 
    
    if(JPEG_FOUND)
        list( APPEND _grib_api_jpg_incs ${JPEG_INCLUDE_DIR} )
        list( APPEND _grib_api_jpg_libs ${JPEG_LIBRARIES} )
    endif()
    if(JASPER_FOUND)
        list( APPEND _grib_api_jpg_incs ${JASPER_INCLUDE_DIR} )
        list( APPEND _grib_api_jpg_libs ${JASPER_LIBRARIES} )
    endif()
    if(OPENJPEG_FOUND)
        list( APPEND _grib_api_jpg_incs ${OPENJPEG_INCLUDE_DIR} )
        list( APPEND _grib_api_jpg_libs ${OPENJPEG_LIBRARIES} )
    endif()
    
    # png support
    
    find_package(PNG)

    if( DEFINED PNG_PNG_INCLUDE_DIR AND NOT DEFINED PNG_INCLUDE_DIRS )
      set( PNG_INCLUDE_DIRS ${PNG_PNG_INCLUDE_DIR}  CACHE INTERNAL "PNG include dirs" )
    endif()
    if( DEFINED PNG_LIBRARY AND NOT DEFINED PNG_LIBRARIES )
      set( PNG_LIBRARIES ${PNG_LIBRARY} CACHE INTERNAL "PNG libraries" )
    endif()
    
    if(PNG_FOUND)
        list( APPEND _grib_api_png_defs ${PNG_DEFINITIONS} )
        list( APPEND _grib_api_png_incs ${PNG_INCLUDE_DIRS} )
        list( APPEND _grib_api_png_libs ${PNG_LIBRARIES} )
    endif()

    # find external grib_api

    if( NOT DEFINED GRIB_API_PATH AND NOT "$ENV{GRIB_API_PATH}" STREQUAL "" )
        list( APPEND GRIB_API_PATH "$ENV{GRIB_API_PATH}" )
    endif()

    if( DEFINED GRIB_API_PATH )
        find_path(GRIB_API_INCLUDE_DIR NAMES grib_api.h PATHS ${GRIB_API_PATH} ${GRIB_API_PATH}/include PATH_SUFFIXES grib_api  NO_DEFAULT_PATH)
        find_library(GRIB_API_LIBRARY  NAMES grib_api   PATHS ${GRIB_API_PATH} ${GRIB_API_PATH}/lib     PATH_SUFFIXES grib_api  NO_DEFAULT_PATH)
    endif()
    
    find_path(GRIB_API_INCLUDE_DIR NAMES grib_api.h PATH_SUFFIXES grib_api )
    find_library( GRIB_API_LIBRARY NAMES grib_api   PATH_SUFFIXES grib_api )
    
    set( GRIB_API_LIBRARIES    ${GRIB_API_LIBRARY} )
    set( GRIB_API_INCLUDE_DIRS ${GRIB_API_INCLUDE_DIR} )
    
    include(FindPackageHandleStandardArgs)
    
    # handle the QUIETLY and REQUIRED arguments and set GRIB_API_FOUND to TRUE
    # if all listed variables are TRUE
    find_package_handle_standard_args(GRIB_API  DEFAULT_MSG
                                      GRIB_API_LIBRARY GRIB_API_INCLUDE_DIR)
    
    mark_as_advanced(GRIB_API_INCLUDE_DIR GRIB_API_LIBRARY )
    
    list( APPEND GRIB_API_DEFINITIONS  ${_grib_api_jpg_defs} ${_grib_api_png_defs} )
    list( APPEND GRIB_API_INCLUDE_DIRS ${_grib_api_jpg_incs} ${_grib_api_png_incs} )
    list( APPEND GRIB_API_LIBRARIES    ${_grib_api_jpg_libs} ${_grib_api_png_libs} )

endif()
