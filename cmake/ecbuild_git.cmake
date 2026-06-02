# (C) Copyright 2011- ECMWF.
#
# This software is licensed under the terms of the Apache Licence Version 2.0
# which can be obtained at http://www.apache.org/licenses/LICENSE-2.0.
# In applying this licence, ECMWF does not waive the privileges and immunities
# granted to it by virtue of its status as an intergovernmental organisation
# nor does it submit to any jurisdiction.

set( ECBUILD_GIT  ON  CACHE BOOL "Turn on/off ecbuild_git() function" )

mark_as_advanced(ECBUILD_GIT)

if( ECBUILD_GIT )
  find_package(Git)
endif()

##############################################################################
#.rst:
#
# ecbuild_git
# ===========
#
# Manages an external Git repository. ::
#
#   ecbuild_git( PROJECT <name>
#                DIR <directory>
#                URL <giturl>
#                [ BRANCH <gitbranch> | TAG <gittag> ]
#                [ UPDATE | NOREMOTE ]
#                [ MANUAL ]
#                [ RECURSIVE ]
#                [ SHALLOW ] )
#
# Options
# -------
#
# PROJECT : required
#   project name for the Git repository to be managed
#
# DIR : required
#   directory to clone the repository into (can be relative)
#
# URL : required
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
# RECURSIVE : optional
#   Do a recursive fetch or update
#
# SHALLOW : optional
#   Do a shallow clone (``--depth 1``) on initial checkout.
#   When combined with RECURSIVE, submodules are also fetched at depth 1.
#   Cannot be combined with TAG when it's a commit ID (SHA).
#   When using the SHALLOW option, attempting to switch branch/tag will result in a failure.
#   The SHALLOW option will fail if used in combination with UPDATE.
#   The SHALLOW option will fail if used in combination with NOREMOTE.
#
##############################################################################

function( ecbuild_git )

  set( options UPDATE NOREMOTE MANUAL RECURSIVE SHALLOW )
  set( single_value_args PROJECT DIR URL TAG BRANCH )
  set( multi_value_args )
  cmake_parse_arguments( _PAR "${options}" "${single_value_args}" "${multi_value_args}" ${_FIRST_ARG} ${ARGN} )

  if( DEFINED _PAR_BRANCH AND DEFINED _PAR_TAG )
    ecbuild_critical( "Cannot defined both BRANCH and TAG in macro ecbuild_git" )
  endif()

  if( _PAR_UPDATE AND _PAR_NOREMOTE )
    ecbuild_critical( "Cannot pass both NOREMOTE and UPDATE in macro ecbuild_git" )
  endif()

  if( _PAR_UPDATE AND _PAR_SHALLOW )
    ecbuild_critical("Cannot pass both UPDATE and SHALLOW in ecbuild_git.")
  endif()

  if( _PAR_NOREMOTE AND _PAR_SHALLOW )
    ecbuild_critical("Cannot pass both NOREMOTE and SHALLOW in ecbuild_git.")
  endif()

  if(_PAR_UNPARSED_ARGUMENTS)
    ecbuild_critical("Unknown keywords given to ecbuild_git(): \"${_PAR_UNPARSED_ARGUMENTS}\"")
  endif()

  if( _PAR_SHALLOW AND DEFINED _PAR_TAG )
    string(LENGTH "${_PAR_TAG}" _tag_len)
    if( _tag_len GREATER_EQUAL 7 AND _tag_len LESS_EQUAL 40 AND _PAR_TAG MATCHES "^[0-9a-fA-F]+$" )
      ecbuild_critical("SHALLOW cloning cannot be used: TAG (${_PAR_TAG}) looks like a commit ID (SHA)!")
    endif()
  endif()

  if( ECBUILD_GIT )

    set( _needs_switch 0 )
    set( _created_repo 0 )

    get_filename_component( ABS_PAR_DIR "${_PAR_DIR}" ABSOLUTE )
    get_filename_component( PARENT_DIR  "${_PAR_DIR}/.." ABSOLUTE )

    ### skip if direcory exists but is not a git repo
    if( EXISTS "${_PAR_DIR}" AND IS_DIRECTORY "${_PAR_DIR}" AND NOT IS_DIRECTORY "${_PAR_DIR}/.git" )
      ecbuild_info("Found source directory ${_PAR_DIR}. Not a GIT repo -- skipping git operations")
      return()
    endif()

    ### clone if no directory

    if( NOT EXISTS "${_PAR_DIR}" )

      set( _clone_args )
      if( _PAR_SHALLOW )
        list( APPEND _clone_args "--depth" "1" )
        if( DEFINED _PAR_BRANCH )
          list( APPEND _clone_args "--branch" "${_PAR_BRANCH}" )
        elseif( DEFINED _PAR_TAG )
          list( APPEND _clone_args "--branch" "${_PAR_TAG}" )
        endif()
      endif()

      ecbuild_info( "Cloning ${_PAR_PROJECT} from ${_PAR_URL} into ${_PAR_DIR}...")
      execute_process(
        COMMAND ${GIT_EXECUTABLE} "clone" ${_PAR_URL} ${_clone_args} ${_PAR_DIR} "-q"
        RESULT_VARIABLE nok ERROR_VARIABLE error
        WORKING_DIRECTORY "${PARENT_DIR}")
      if(nok)
        ecbuild_critical("${_PAR_DIR} git clone failed:\n  ${GIT_EXECUTABLE} clone ${_PAR_URL} ${_clone_args} ${_PAR_DIR} -q\n  ${error}\n")
      endif()
      ecbuild_info( "${_PAR_DIR} retrieved.")
      set( _created_repo 1 )
      set( _needs_switch 1 )

    endif()

    ### check current tag and sha1

    if( IS_DIRECTORY "${_PAR_DIR}/.git" )

      execute_process( COMMAND ${GIT_EXECUTABLE} rev-parse HEAD
                       OUTPUT_VARIABLE _sha1 RESULT_VARIABLE nok ERROR_VARIABLE error
                       OUTPUT_STRIP_TRAILING_WHITESPACE
                       WORKING_DIRECTORY "${ABS_PAR_DIR}" )
      if(nok)
        ecbuild_info("git rev-parse HEAD on ${_PAR_DIR} failed:\n ${error}")
      endif()

      execute_process( COMMAND ${GIT_EXECUTABLE} rev-parse --abbrev-ref HEAD
                       OUTPUT_VARIABLE _current_branch RESULT_VARIABLE nok ERROR_VARIABLE error
                       OUTPUT_STRIP_TRAILING_WHITESPACE
                       WORKING_DIRECTORY "${ABS_PAR_DIR}" )
      if( nok OR _current_branch STREQUAL "" )
        ecbuild_info("git rev-parse --abbrev-ref HEAD on ${_PAR_DIR} failed:\n ${error}")
      endif()

      execute_process( COMMAND ${GIT_EXECUTABLE} describe --exact-match --abbrev=0
                       OUTPUT_VARIABLE _current_tag RESULT_VARIABLE nok ERROR_VARIABLE error
                       OUTPUT_STRIP_TRAILING_WHITESPACE  ERROR_STRIP_TRAILING_WHITESPACE
                       WORKING_DIRECTORY "${ABS_PAR_DIR}" )

      if( error MATCHES "no tag exactly matches" OR error MATCHES "No names found" )
        unset( _current_tag )
      else()
        if( nok )
          ecbuild_info("git describe --exact-match --abbrev=0 on ${_PAR_DIR} failed:\n ${error}")
        endif()
      endif()

      if( NOT _current_tag ) # try nother method
        execute_process( COMMAND ${GIT_EXECUTABLE} name-rev --tags --name-only ${_sha1}
                         OUTPUT_VARIABLE _current_tag RESULT_VARIABLE nok ERROR_VARIABLE error
                         OUTPUT_STRIP_TRAILING_WHITESPACE
                         WORKING_DIRECTORY "${ABS_PAR_DIR}" )
        if( nok OR _current_tag STREQUAL "" )
          ecbuild_info("git name-rev --tags --name-only on ${_PAR_DIR} failed:\n ${error}")
        endif()
      endif()

    endif()

    if( NOT _PAR_MANUAL AND DEFINED _PAR_BRANCH AND NOT "${_current_branch}" STREQUAL "${_PAR_BRANCH}" )
      set( _needs_switch 1 )
    endif()

    if( NOT _PAR_MANUAL AND DEFINED _PAR_TAG AND NOT "${_current_tag}" STREQUAL "${_PAR_TAG}" )
      set( _needs_switch 1 )
    endif()

    if( _PAR_SHALLOW AND _needs_switch AND NOT _created_repo )
      ecbuild_critical("SHALLOW repository ${_PAR_DIR} is not switchable.")
    endif()

    if( DEFINED _PAR_BRANCH AND _PAR_UPDATE AND NOT _PAR_NOREMOTE AND NOT _PAR_SHALLOW )

      add_custom_target( git_update_${_PAR_PROJECT}
                         COMMAND "${GIT_EXECUTABLE}" pull -q
                         WORKING_DIRECTORY "${ABS_PAR_DIR}"
                         COMMENT "git pull of branch ${_PAR_BRANCH} on ${_PAR_DIR}" )

      set( git_update_targets "git_update_${_PAR_PROJECT};${git_update_targets}" PARENT_SCOPE )

    endif()

    ### updates

    if( _needs_switch AND IS_DIRECTORY "${_PAR_DIR}/.git" )

      if( DEFINED _PAR_BRANCH )
        set ( _gitref ${_PAR_BRANCH} )
        ecbuild_info("Updating ${_PAR_PROJECT} to head of BRANCH ${_PAR_BRANCH}...")
      else()
        ecbuild_info("Updating ${_PAR_PROJECT} to TAG ${_PAR_TAG}...")
        set ( _gitref ${_PAR_TAG} )
      endif()

      # fetching latest tags and branches

      if( _PAR_SHALLOW )
        ecbuild_info("${_PAR_DIR} is SHALLOW : Skipping fetch")
      elseif( NOT _PAR_NOREMOTE )

        ecbuild_info("git fetch --all @ ${ABS_PAR_DIR}")
        execute_process( COMMAND "${GIT_EXECUTABLE}" fetch --all -q
                         RESULT_VARIABLE nok ERROR_VARIABLE error
                         WORKING_DIRECTORY "${ABS_PAR_DIR}")
        if(nok)
          ecbuild_warn("git fetch --all in ${_PAR_DIR} failed:\n ${error}")
        endif()

        ecbuild_info("git fetch --all --tags @ ${ABS_PAR_DIR}")
        execute_process( COMMAND "${GIT_EXECUTABLE}" fetch --all --tags -q
                         RESULT_VARIABLE nok ERROR_VARIABLE error
                         WORKING_DIRECTORY "${ABS_PAR_DIR}")
        if(nok)
          ecbuild_warn("git fetch --all --tags in ${_PAR_DIR} failed:\n ${error}")
        endif()

      else()
        ecbuild_info("${_PAR_DIR} marked NOREMOTE : Skipping git fetch")
      endif()

      # checking out gitref

      ecbuild_info("git checkout ${_gitref} @ ${ABS_PAR_DIR}")
      execute_process( COMMAND "${GIT_EXECUTABLE}" checkout -q "${_gitref}"
                       RESULT_VARIABLE nok ERROR_VARIABLE error
                       WORKING_DIRECTORY "${ABS_PAR_DIR}")
      if(nok)
        ecbuild_critical("git checkout ${_gitref} on ${_PAR_DIR} failed:\n  ${GIT_EXECUTABLE} checkout -q ${_gitref}\n  ${error}")
      endif()

      if( DEFINED _PAR_BRANCH AND _PAR_UPDATE AND NOT _PAR_SHALLOW ) #############################

        # Use git pull --ff-only, we WANT this to fail on upstream rebase and
        # we DON'T want merge commits here!
        # Skipped for SHALLOW clones to avoid deepening history.
        execute_process( COMMAND "${GIT_EXECUTABLE}" pull -q --ff-only
                         RESULT_VARIABLE nok ERROR_VARIABLE error
                         WORKING_DIRECTORY "${ABS_PAR_DIR}")
        if(nok)
          ecbuild_critical("git pull of branch ${_PAR_BRANCH} on ${_PAR_DIR} failed:\n ${error}")
        endif()

      endif() ####################################################################################

      if( _PAR_RECURSIVE )
        set( _submodule_args submodule --quiet update --init --recursive )
        if( _PAR_SHALLOW )
          list( APPEND _submodule_args "--depth" "1" )
        endif()
        ecbuild_info("git ${_submodule_args} @ ${ABS_PAR_DIR}")
        execute_process( COMMAND "${GIT_EXECUTABLE}" ${_submodule_args}
                        RESULT_VARIABLE nok ERROR_VARIABLE error
                        WORKING_DIRECTORY "${ABS_PAR_DIR}")
        if(nok)
          ecbuild_critical("git submodule update --init --recursive in ${_PAR_DIR} failed:\n ${error}")
        endif()
      endif()

    endif( _needs_switch AND IS_DIRECTORY "${_PAR_DIR}/.git" )

  endif( ECBUILD_GIT )

endfunction()
