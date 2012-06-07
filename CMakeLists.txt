############################################################################################
# cmake
#   options:
#       -DCMAKE_BUILD_TYPE=Debug|RelWithDebInfo|Release|Production
#       -DCMAKE_INSTALL_PREFIX=/path/to/install
#
#       -DCMAKE_C_COMPILER=gcc
#       -DCMAKE_C_COMPILER=g++
#
#       -DCMAKE_PREFIX_PATH=/path/to/jasper:/path/to/any/package/out/of/place

cmake_minimum_required( VERSION 2.6.4 FATAL_ERROR )

project( ecbuild )

set( CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/cmake" ${CMAKE_MODULE_PATH} )

include( ecbuild_system )

###############################################################################
# local project

ecbuild_declare_project()

# TODO: rename to ecbuild_*

configure_file( cmake/ecbase_version.h.in   ${CMAKE_BINARY_DIR}/ecbase_version.h  )

# contents

ecbuild_add_resources( TARGET ${PROJECT_NAME}_description_files
                     SOURCES_PACK
                        Installation.pdf
                        INSTALL
                        AUTHORS
                        NOTICE
                        LICENSE
                        COPYING
                     DONT_PACK_REGEX "configure.*"
)

install( DIRECTORY cmake DESTINATION share/ecbase )

add_subdirectory( tools  )

include_directories( ${CMAKE_CURRENT_SOURCE_DIR} ${CMAKE_CURRENT_BINARY_DIR} )

set( ECMWF_PROJECTS "" CACHE INTERNAL "list of (sub)projects" )

ecbuild_add_subproject( ecflow )

ecbuild_add_subproject( grib_api )

ecbuild_add_subproject( libemos )

ecbuild_add_subproject( fdb )

# ecbuild_add_subproject( bufr_api )

ecbuild_add_subproject( spotdb )

ecbuild_add_subproject( eclib )

ecbuild_add_subproject( odb_api )

ecbuild_add_subproject( mars_server )

ecbuild_add_subproject( mars_client )

############################################################################################
# summary

# print the summary of the configuration
include( ecbuild_print_summary )
