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

##############################################################################
#.rst:
#
# ecbuild_bundle_initialize
# =========================
#
# Initialise the ecBuild environment for a bundle. *Must* be called *before*
# any call to ecbuild_bundle.
#
##############################################################################

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

##############################################################################
#.rst:
#
# ecbuild_bundle
# ==============
#
# Declare a subproject to be built as part of this bundle. ::
#
#   ecbuild_bundle( PROJECT <name>
#                   STASH <repository> | GIT <giturl>
#                   [ BRANCH <gitbranch> | TAG <gittag> ]
#                   [ UPDATE | NOREMOTE ] )
#                   [ MANUAL ] )
#
# Options
# -------
#
# PROJECT : required
#   project name for the Git repository to be managed
#
# STASH : cannot be combined with GIT, either is required
#   Stash repository in the form <project>/<repository>
#
# URL : cannot be combined with STASH, either is required
#   Git URL of the remote repository to clone (see ``git help clone``)
#
# BRANCH : optional, cannot be combined with TAG
#   Git branch to check out
#
# TAG : optional, cannot be combined with BRANCH
#   Git tag or commit id to check out
#
# UPDATE : optional, requires BRANCH, cannot be combined with NOREMOTE
#   Create a CMake target update to fetch changes from the remote repository
#
# NOREMOTE : optional, cannot be combined with UPDATE
#   Do not fetch changes from the remote repository
#
# MANUAL : optional
#   Do not automatically switch branches or tags
#
##############################################################################

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

##############################################################################
#.rst:
#
# ecbuild_bundle_finalize
# =======================
#
# Finalise the ecBuild environment for a bundle. *Must* be called *after* the
# last call to ecbuild_bundle.
#
##############################################################################

macro( ecbuild_bundle_finalize )

  add_custom_target( update DEPENDS ${git_update_targets} )

  ecbuild_install_project( NAME ${CMAKE_PROJECT_NAME} )

  ecbuild_print_summary()

endmacro()
