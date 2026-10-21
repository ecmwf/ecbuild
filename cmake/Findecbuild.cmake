# SPDX-FileCopyrightText: 2011- European Centre for Medium-Range Weather Forecasts (ECMWF)
# SPDX-License-Identifier: Apache-2.0

find_path(ecbuild_MACROS_DIR ecbuild.cmake
    HINTS
        ${CMAKE_CURRENT_LIST_DIR}
    PATH_SUFFIXES
        cmake
        share/cmake
        share/ecbuild/cmake
    NO_DEFAULT_PATH
    NO_CMAKE_FIND_ROOT_PATH)

if(ecbuild_MACROS_DIR)
    include(${ecbuild_MACROS_DIR}/ecbuild_parse_version.cmake)
    ecbuild_parse_version_file(${ecbuild_MACROS_DIR}/VERSION PREFIX ecbuild)
endif()

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(ecbuild
    REQUIRED_VARS
        ecbuild_MACROS_DIR
    VERSION_VAR
        ecbuild_VERSION)

if(ecbuild_FOUND)
    include(ecbuild)
    find_path(ecbuild_DIR ecbuild-config.cmake
        HINTS
            ${CMAKE_CURRENT_LIST_DIR}/../
            ${CMAKE_CURRENT_LIST_DIR}/../../../
        PATH_SUFFIXES
            lib/cmake/ecbuild
            lib64/cmake/ecbuild
            lib/${CMAKE_LIBRARY_ARCHITECTURE}/cmake/ecbuild
        NO_DEFAULT_PATH
        NO_CMAKE_FIND_ROOT_PATH)
endif()
