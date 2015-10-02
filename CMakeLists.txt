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

if( ENABLE_INSTALL )
	install( DIRECTORY cmake DESTINATION ${INSTALL_DATA_DIR} PATTERN "CMakeLists.txt" EXCLUDE )
endif()

############################################################################################
# finalize

ecbuild_install_project( NAME ${PROJECT_NAME} )

ecbuild_print_summary()
