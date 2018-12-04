# (C) Copyright 2011- ECMWF.
#
# This software is licensed under the terms of the Apache Licence Version 2.0
# which can be obtained at http://www.apache.org/licenses/LICENSE-2.0.
# In applying this licence, ECMWF does not waive the privileges and immunities
# granted to it by virtue of its status as an intergovernmental organisation
# nor does it submit to any jurisdiction.

############################################################################################
# cmake options:
#
#       -DCMAKE_INSTALL_PREFIX=/path/to/install

cmake_minimum_required( VERSION 3.6.0 FATAL_ERROR )

include( cmake/VERSION.cmake )
project( ecbuild VERSION ${ecbuild_VERSION} LANGUAGES C )

set( CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/cmake" ${CMAKE_MODULE_PATH} )

include( ecbuild_system )

if(ECBUILD_2_COMPAT)
  ecbuild_declare_compat( ecbuild_VERSION_STR ecbuild_VERSION )
  ecbuild_declare_compat( ECBUILD_VERSION_STR ecbuild_VERSION )
  ecbuild_declare_compat( ECBUILD_MAJOR_VERSION ecbuild_VERSION_MAJOR )
  ecbuild_declare_compat( ECBUILD_MINOR_VERSION ecbuild_VERSION_MINOR )
  ecbuild_declare_compat( ECBUILD_PATCH_VERSION ecbuild_VERSION_PATCH )
endif()

###############################################################################
# local project

ecbuild_declare_project()

configure_file( cmake/ecbuild_version.h.in ${CMAKE_BINARY_DIR}/ecbuild_version.h  )

ecbuild_add_option( FEATURE INSTALL
                    DEFAULT OFF
                    DESCRIPTION "Wether to install ecbuild files" )
# contents

ecbuild_add_resources(  TARGET ${PROJECT_NAME}_description_files
                        SOURCES_PACK
                            INSTALL
                            AUTHORS
                            NOTICE
                            LICENSE
                            COPYING
)

add_subdirectory( bin )
add_subdirectory( share )
add_subdirectory( cmake )
add_subdirectory( doc )

add_subdirectory( regressions )
add_subdirectory( tests )

install( DIRECTORY cmake DESTINATION ${INSTALL_DATA_DIR} PATTERN "CMakeLists.txt" EXCLUDE )

############################################################################################
# finalize

ecbuild_install_project( NAME ${PROJECT_NAME} )

ecbuild_print_summary()
