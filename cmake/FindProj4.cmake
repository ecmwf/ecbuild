# - Try to find the proj4 library
# Once done this will define
#
# PROJ4_FOUND - system has proj4
# PROJ4_INCLUDE_DIRS - the proj4 include directory
# PROJ4_LIBRARIES - Link these to use proj4
#
# Define PROJ4_MIN_VERSION for which version desired.

ecbuild_add_extra_search_paths( proj4 )

if( NOT DEFINED PROJ4_PATH AND NOT "$ENV{PROJ4_PATH}" STREQUAL "" )
    set( APPEND PROJ4_PATH "$ENV{PROJ4_PATH}" )
endif()

if( NOT DEFINED PROJ4_PATH )

    include(FindPkgConfig)

    if(Proj4_FIND_REQUIRED)
        set(_pkgconfig_REQUIRED "REQUIRED")
    else()
        set(_pkgconfig_REQUIRED "")
    endif()

    if(PROJ4_MIN_VERSION)
        pkg_check_modules(PKPROJ4 ${_pkgconfig_REQUIRED} proj4>=${PROJ4_MIN_VERSION})
    else()
        pkg_check_modules(PKPROJ4 ${_pkgconfig_REQUIRED} proj4)
    endif()

    if( PKG_CONFIG_FOUND AND PKPROJ4_FOUND )

        find_path(PROJ4_INCLUDE_DIR proj_api.h HINTS ${PKPROJ4_INCLUDEDIR} ${PKPROJ4_INCLUDE_DIRS} PATH_SUFFIXES proj4 NO_DEFAULT_PATH )
        find_library(PROJ4_LIBRARY  proj       HINTS ${PKPROJ4_LIBDIR}     ${PKPROJ4_LIBRARY_DIRS} PATH_SUFFIXES proj4 NO_DEFAULT_PATH )

    endif()

else()

    find_path(PROJ4_INCLUDE_DIR proj_api.h PATHS ${PROJ4_PATH}/include PATH_SUFFIXES proj4 NO_DEFAULT_PATH )
    find_library(PROJ4_LIBRARY  proj       PATHS ${PROJ4_PATH}/lib     PATH_SUFFIXES proj4 NO_DEFAULT_PATH )

endif()

find_path(PROJ4_INCLUDE_DIR proj_api.h PATH_SUFFIXES proj4 )
find_library( PROJ4_LIBRARY proj       PATH_SUFFIXES proj4 )

set( PROJ4_LIBRARIES    ${PROJ4_LIBRARY} )
set( PROJ4_INCLUDE_DIRS ${PROJ4_INCLUDE_DIR} )

include(FindPackageHandleStandardArgs)

# handle the QUIETLY and REQUIRED arguments and set GRIBAPI_FOUND to TRUE
# if all listed variables are TRUE
find_package_handle_standard_args(PROJ4  DEFAULT_MSG
                                  PROJ4_LIBRARY PROJ4_INCLUDE_DIR)

mark_as_advanced( PROJ4_INCLUDE_DIR PROJ4_LIBRARY )
