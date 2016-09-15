cmake_minimum_required( VERSION 2.8.4 FATAL_ERROR )

set( CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} "${CMAKE_CURRENT_SOURCE_DIR}/../../cmake" )

include( ecbuild_bundle )

project( override_compile_flags C Fortran )

ecbuild_bundle_initialize()

ecbuild_bundle( PROJECT bar )
ecbuild_bundle( PROJECT foo )

ecbuild_bundle_finalize()
