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

set( CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/cmake" ${CMAKE_MODULE_PATH} )


include( ecbuild )
project( ecbuild LANGUAGES NONE )

###############################################################################
# local project

configure_file( cmake/ecbuild_version.h.in ${CMAKE_BINARY_DIR}/ecbuild_version.h  )

# contents

ecbuild_add_resources(  TARGET ${PROJECT_NAME}_description_files
                        SOURCES_PACK
                            README.rst
                            INSTALL.rst
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
