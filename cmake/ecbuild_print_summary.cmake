# (C) Copyright 1996-2012 ECMWF.
#
# This software is licensed under the terms of the Apache Licence Version 2.0
# which can be obtained at http://www.apache.org/licenses/LICENSE-2.0.
# In applying this licence, ECMWF does not waive the privileges and immunities
# granted to it by virtue of its status as an intergovernmental organisation nor
# does it submit to any jurisdiction.

macro( ecbuild_print_summary )

	message( STATUS "---------------------------------------------------------" )
	message( STATUS " Project ${PROJECT_NAME} summary" )
	message( STATUS "---------------------------------------------------------" )

    if( EXISTS ${PROJECT_SOURCE_DIR}/project_summary.cmake )
        include( ${PROJECT_SOURCE_DIR}/project_summary.cmake )
    endif()

	feature_summary(	WHAT ALL
						INCLUDE_QUIET_PACKAGES )

    if( ${PROJECT_NAME} STREQUAL ${CMAKE_PROJECT_NAME} )

        ecbuild_define_links_target()

        get_property( langs GLOBAL PROPERTY ENABLED_LANGUAGES )

		message( STATUS "---------------------------------------------------------" )
		message( STATUS " Build summary" )
		message( STATUS "---------------------------------------------------------" )

		message( STATUS " operating system : [${CMAKE_SYSTEM}] [${EC_OS_NAME}.${EC_OS_BITS}]" )
		message( STATUS " processor        : [${CMAKE_SYSTEM_PROCESSOR}]" )
        message( STATUS " cmake            : [${CMAKE_COMMAND}] (${CMAKE_MAJOR_VERSION}.${CMAKE_MINOR_VERSION}.${CMAKE_PATCH_VERSION})" )
        message( STATUS " build type       : [${CMAKE_BUILD_TYPE}]" )
        message( STATUS " timestamp        : [${EC_BUILD_TIMESTAMP}]" )
        message( STATUS " install prefix   : [${CMAKE_INSTALL_PREFIX}]" )
    if( EC_LINK_DIR )
        message( STATUS " links prefix     : [${EC_LINK_DIR}]" )
    endif()
        message( STATUS "---------------------------------------------------------" )

        foreach( lang ${langs} )
		  message( STATUS " ${lang} > ${CMAKE_${lang}_COMPILER_ID} ${CMAKE_${lang}_COMPILER_VERSION} [${CMAKE_${lang}_COMPILER} ${CMAKE_${lang}_FLAGS} ${CMAKE_${lang}_FLAGS_${CMAKE_BUILD_TYPE_CAPS}}]" )
        endforeach()

	message( STATUS "link flags :" )
	message( STATUS "    exe       : [${CMAKE_EXE_LINKER_FLAGS} ${CMAKE_EXEC_LINKER_FLAGS_${CMAKE_BUILD_TYPE_CAPS}}]" )
	message( STATUS "    shared lib: [${CMAKE_SHARED_LINKER_FLAGS} ${CMAKE_SHARED_LINKER_FLAGS_${CMAKE_BUILD_TYPE_CAPS}}]" )
	message( STATUS "    static lib: [${CMAKE_MODULE_LINKER_FLAGS} ${CMAKE_MODULE_LINKER_FLAGS_${CMAKE_BUILD_TYPE_CAPS}}]" )

        message( STATUS "---------------------------------------------------------" )

    if( EC_BIG_ENDIAN )
        message( STATUS " Big endian [${EC_BIG_ENDIAN}] IEEE BE [${IEEE_BE}]" )
    endif()
    if( EC_LITTLE_ENDIAN )
        message( STATUS " Little endian [${EC_LITTLE_ENDIAN}] IEEE LE [${IEEE_LE}]" )
    endif()

        message( STATUS " sizeof - void*  [${EC_SIZEOF_PTR}] - size_t [${EC_SIZEOF_SIZE_T}] - off_t  [${EC_SIZEOF_OFF_T}]" )
        message( STATUS "        - short  [${EC_SIZEOF_SHORT}] - int    [${EC_SIZEOF_INT}] - long   [${EC_SIZEOF_LONG}] - long long [${EC_SIZEOF_LONG_LONG}]" )
        message( STATUS "        - float  [${EC_SIZEOF_FLOAT}] - double [${EC_SIZEOF_DOUBLE}] - long double [${EC_SIZEOF_LONG_DOUBLE}]" )

        message( STATUS "---------------------------------------------------------" )

    endif()

    # issue warnings / errors in case there are unused project files
    ecbuild_warn_unused_files()

    # issue a warning that 'make install' mighty be broken for old cmakes
    if( ${CMAKE_VERSION} VERSION_LESS "2.8.3" )

        message( STATUS " +++ WARNING +++ WARNING +++ WARNING +++" )
        message( STATUS " +++ " )
        message( STATUS " +++ This CMake version [${CMAKE_VERSION}] is rather OLD" )
        message( STATUS " +++ " )
        message( STATUS " +++ We work hard to keep CMake backward compatibility (support >= 2.6.4)" )
        message( STATUS " +++ but there are some limits inherent to older versions." )
        message( STATUS " +++ " )
        message( STATUS " +++ You will be able to build the software... " )
        message( STATUS " +++ " )
        message( STATUS " +++ But: " )
        message( STATUS " +++     * the 'make install' target most likely will NOT WORK" )
        message( STATUS " +++     * if you want to install these binaries you might need to copy them by yourself" )
        message( STATUS " +++     * the binaries are in '${CMAKE_BINARY_DIR}' /lib and /bin" )
        message( STATUS " +++     * copying headers will take substantially more work, and you might end up copying files that won't be needed" )
        message( STATUS " +++ " )
        message( STATUS " +++ Therefore, we recommend that you:  " )
        message( STATUS " +++     * upgrade to a newer CMake with version at least >= 2.8.3" )
        message( STATUS " +++     * remove this build directory '${CMAKE_BINARY_DIR}'" )
        message( STATUS " +++     * rerun a newer cmake on an new empty build directory" )
        message( STATUS " +++ " )
        message( STATUS " +++ WARNING +++ WARNING +++ WARNING +++" )

    endif()

endmacro( ecbuild_print_summary )
