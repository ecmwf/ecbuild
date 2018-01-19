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

cmake_minimum_required( VERSION 2.8.4 FATAL_ERROR )

project( ecbuild C )

set( CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/cmake" ${CMAKE_MODULE_PATH} )

include( ecbuild_system )

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

install( DIRECTORY cmake DESTINATION ${INSTALL_DATA_DIR} PATTERN "CMakeLists.txt" EXCLUDE )

############################################################################################
# finalize

ecbuild_install_project( NAME ${PROJECT_NAME} )

ecbuild_print_summary()
