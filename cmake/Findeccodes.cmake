# (C) Copyright 1996-2016 ECMWF.
#
# This software is licensed under the terms of the Apache Licence Version 2.0
# which can be obtained at http://www.apache.org/licenses/LICENSE-2.0.
# In applying this licence, ECMWF does not waive the privileges and immunities
# granted to it by virtue of its status as an intergovernmental organisation nor
# does it submit to any jurisdiction.

# - Try to find ECCODES
# Once done this will define
#  ECCODES_FOUND - System has ECCODES
#  ECCODES_INCLUDE_DIRS - The ECCODES include directories
#  ECCODES_LIBRARIES - The libraries needed to use ECCODES
#  ECCODES_DEFINITIONS - Compiler switches required for using ECCODES

option( NO_ECCODES_BINARIES "skip trying to find eccodes installed binaries" OFF )
option( ECCODES_PNG "use png with eccodes" ON )
option( ECCODES_JPG "use jpg with eccodes" ON )

if( NOT eccodes_FOUND AND NOT NO_ECCODES_BINARIES )

    if( ECCODES_JPG ) # jpeg support

        find_package( JPEG     QUIET ) # eccodes might be a static .a library in which

        if( NOT "$ENV{JASPER_PATH}" STREQUAL "" )
            list( APPEND CMAKE_PREFIX_PATH "$ENV{JASPER_PATH}" )
        endif()
        find_package( Jasper   QUIET ) # case we don't know if which jpeg library was used

        find_package( OpenJPEG QUIET ) # so we try to find all jpeg libs and link to them

        if(JPEG_FOUND)
            list( APPEND _eccodes_jpg_incs ${JPEG_INCLUDE_DIR} )
            list( APPEND _eccodes_jpg_libs ${JPEG_LIBRARIES} )
        endif()
        if(JASPER_FOUND)
            list( APPEND _eccodes_jpg_incs ${JASPER_INCLUDE_DIR} )
            list( APPEND _eccodes_jpg_libs ${JASPER_LIBRARIES} )
        endif()
        if(OPENJPEG_FOUND)
            list( APPEND _eccodes_jpg_incs ${OPENJPEG_INCLUDE_DIR} )
            list( APPEND _eccodes_jpg_libs ${OPENJPEG_LIBRARIES} )
        endif()

    endif()

    if( ECCODES_PNG ) # png support

        find_package(PNG)

        if( DEFINED PNG_PNG_INCLUDE_DIR AND NOT DEFINED PNG_INCLUDE_DIRS )
          set( PNG_INCLUDE_DIRS ${PNG_PNG_INCLUDE_DIR}  CACHE INTERNAL "PNG include dirs" )
        endif()
        if( DEFINED PNG_LIBRARY AND NOT DEFINED PNG_LIBRARIES )
          set( PNG_LIBRARIES ${PNG_LIBRARY} CACHE INTERNAL "PNG libraries" )
        endif()

        if(PNG_FOUND)
            list( APPEND _eccodes_png_defs ${PNG_DEFINITIONS} )
            list( APPEND _eccodes_png_incs ${PNG_INCLUDE_DIRS} )
            list( APPEND _eccodes_png_libs ${PNG_LIBRARIES} )
        endif()

    endif()

	# The eccodes on macos that comes with 'port' is linked against ghostscript
	if(${CMAKE_SYSTEM_NAME} MATCHES "Darwin")
		find_library(GS_LIBRARIES NAMES gs)
		if( GS_LIBRARIES )
			list( APPEND ECCODES_LIBRARIES ${GS_LIBRARIES} )
		endif()
	endif()

    # find external eccodes

    if( NOT DEFINED ECCODES_PATH AND NOT "$ENV{ECCODES_PATH}" STREQUAL "" )
        list( APPEND ECCODES_PATH "$ENV{ECCODES_PATH}" )
    endif()

    if( DEFINED ECCODES_PATH )
        find_path(ECCODES_INCLUDE_DIR NAMES eccodes.h PATHS ${ECCODES_PATH} ${ECCODES_PATH}/include PATH_SUFFIXES eccodes  NO_DEFAULT_PATH)
        find_library(ECCODES_LIBRARY  NAMES eccodes   PATHS ${ECCODES_PATH} ${ECCODES_PATH}/lib     PATH_SUFFIXES eccodes  NO_DEFAULT_PATH)
        find_library(ECCODES_LIB_F90  NAMES eccodes_f90 PATHS ${ECCODES_PATH} ${ECCODES_PATH}/lib     PATH_SUFFIXES eccodes  NO_DEFAULT_PATH)
        find_library(ECCODES_LIB_F77  NAMES eccodes_f77 PATHS ${ECCODES_PATH} ${ECCODES_PATH}/lib     PATH_SUFFIXES eccodes  NO_DEFAULT_PATH)
        find_program(ECCODES_INFO     NAMES eccodes_info  PATHS ${ECCODES_PATH} ${ECCODES_PATH}/bin   PATH_SUFFIXES eccodes  NO_DEFAULT_PATH)
    endif()

    find_path(ECCODES_INCLUDE_DIR NAMES eccodes.h PATHS PATH_SUFFIXES eccodes )
    find_library( ECCODES_LIBRARY NAMES eccodes   PATHS PATH_SUFFIXES eccodes )
    find_library( ECCODES_LIB_F90 NAMES eccodes_f90 PATHS PATH_SUFFIXES eccodes )
    find_library( ECCODES_LIB_F77 NAMES eccodes_f77 PATHS PATH_SUFFIXES eccodes )
    find_program(ECCODES_INFO     NAMES eccodes_info  PATHS PATH_SUFFIXES eccodes )

    list( APPEND ECCODES_LIBRARIES    ${ECCODES_LIBRARY} ${ECCODES_LIB_F90} ${ECCODES_LIB_F77} )
    set( ECCODES_INCLUDE_DIRS ${ECCODES_INCLUDE_DIR} )

    if( ECCODES_INFO )

        execute_process( COMMAND ${ECCODES_INFO} -v  OUTPUT_VARIABLE _eccodes_info_out ERROR_VARIABLE _eccodes_info_err OUTPUT_STRIP_TRAILING_WHITESPACE )

        # ecbuild_debug_var( _eccodes_info_out )

        string( REPLACE "." " " _version_list ${_eccodes_info_out} ) # dots to spaces
        separate_arguments( _version_list )

        list( GET _version_list 0 ECCODES_MAJOR_VERSION )
        list( GET _version_list 1 ECCODES_MINOR_VERSION )
        list( GET _version_list 2 ECCODES_PATCH_VERSION )

        set( ECCODES_VERSION     "${ECCODES_MAJOR_VERSION}.${ECCODES_MINOR_VERSION}.${ECCODES_PATCH_VERSION}" )
        set( ECCODES_VERSION_STR "${_eccodes_info_out}" )

        set( eccodes_VERSION     "${ECCODES_VERSION}" )
        set( eccodes_VERSION_STR "${ECCODES_VERSION_STR}" )

    endif()

    include(FindPackageHandleStandardArgs)

    # handle the QUIETLY and REQUIRED arguments and set ECCODES_FOUND to TRUE
    find_package_handle_standard_args( eccodes DEFAULT_MSG
                                       ECCODES_LIBRARY ECCODES_INCLUDE_DIR ECCODES_INFO )

    mark_as_advanced( ECCODES_INCLUDE_DIR ECCODES_LIBRARY ECCODES_INFO )

    list( APPEND ECCODES_DEFINITIONS  ${_eccodes_jpg_defs} ${_eccodes_png_defs} )
    list( APPEND ECCODES_INCLUDE_DIRS ${_eccodes_jpg_incs} ${_eccodes_png_incs} )
	list( APPEND ECCODES_LIBRARIES    ${_eccodes_jpg_libs} ${_eccodes_png_libs} )

    set( eccodes_FOUND ${ECCODES_FOUND} )

endif()
