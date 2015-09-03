# (C) Copyright 1996-2015 ECMWF.
#
# This software is licensed under the terms of the Apache Licence Version 2.0
# which can be obtained at http://www.apache.org/licenses/LICENSE-2.0.
# In applying this licence, ECMWF does not waive the privileges and immunities
# granted to it by virtue of its status as an intergovernmental organisation
# nor does it submit to any jurisdiction.

# Set policies
include( ecbuild_policies NO_POLICY_SCOPE )

macro( debug_here VAR )
  message( STATUS " >>>>> ${VAR} [${${VAR}}]")
endmacro()

include(CMakeParseArguments)

include(ecbuild_git)

########################################################################################################################

macro( ecbuild_bundle_initialize )

  include( local-config.cmake OPTIONAL )

  # ecmwf_stash( PROJECT ecbuild DIR ${PROJECT_SOURCE_DIR}/ecbuild STASH "ecsdk/ecbuild" BRANCH develop )

  # set( CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/ecbuild/cmake;${CMAKE_MODULE_PATH}" )

  include( ecbuild_system )

  ecbuild_requires_macro_version( 1.6 )

  ecbuild_declare_project()

  file( GLOB local_config_files RELATIVE ${CMAKE_CURRENT_SOURCE_DIR} *local-config.cmake )

  ecbuild_add_resources( TARGET ecbuild_bundle_dont_pack DONT_PACK "${local_config_files}" )

  if( EXISTS "${PROJECT_SOURCE_DIR}/README.md" )
    add_custom_target( ${PROJECT_NAME}_readme SOURCES "${PROJECT_SOURCE_DIR}/README.md" )
  endif()

endmacro()

########################################################################################################################

macro( ecbuild_bundle )

  set( options )
  set( single_value_args PROJECT STASH GIT )
  set( multi_value_args )
  cmake_parse_arguments( _PAR "${options}" "${single_value_args}" "${multi_value_args}" ${_FIRST_ARG} ${ARGN} )

  string(TOUPPER "${_PAR_PROJECT}" PNAME)

  if( BUNDLE_SKIP_${PNAME} )
      message( STATUS "Skipping bundle project ${PNAME}" )
  else()

      if( _PAR_STASH )
          ecmwf_stash( PROJECT ${_PAR_PROJECT} DIR ${PROJECT_SOURCE_DIR}/${_PAR_PROJECT} STASH ${_PAR_STASH} ${_PAR_UNPARSED_ARGUMENTS} )
      elseif( _PAR_GIT )
          ecbuild_git( PROJECT ${_PAR_PROJECT} DIR ${PROJECT_SOURCE_DIR}/${_PAR_PROJECT} URL ${_PAR_GIT} ${_PAR_UNPARSED_ARGUMENTS} )
      endif()

      ecbuild_use_package( PROJECT ${_PAR_PROJECT} )
  endif()

endmacro()

macro( ecbuild_bundle_finalize )

  add_custom_target( update DEPENDS ${git_update_targets} )

  ecbuild_install_project( NAME ${CMAKE_PROJECT_NAME} )

  ecbuild_print_summary()

endmacro()
