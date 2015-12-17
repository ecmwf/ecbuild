cmake_minimum_required( VERSION 2.8.11 FATAL_ERROR )

set( CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/../../cmake" ${CMAKE_MODULE_PATH} )

include( ecbuild_bundle )
project( config_bundle C )

ecbuild_bundle_initialize()

# Use command "make update" to update branches to latest develop version
ecbuild_bundle( PROJECT subproj1 )
ecbuild_bundle( PROJECT subproj2 )

# Finalize
ecbuild_bundle_finalize()
