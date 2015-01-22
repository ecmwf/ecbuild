# Manages an external git repository
# Usage:
# git(DIR <directory> URL <giturl> [BRANCH <gitbranch>] [TAG <gittag>] [NO_HISTORY] [UPDATE] )
#
# Arguments:
#  - DIR: directory name where repo will be cloned to
#  - URL: location of origin git repository
#  - BRANCH (optional): Branch to clone
#  - TAG (optional): Tag or commit-id to checkout 
#          NOTE -- this clones entire history and overrides NO_HISTORY option
#  - NO_HISTORY (optional) : Option that only makes a shallow clone
#  - UPDATE (optional) : Option to try to update every cmake run

macro( debug_here VAR )
  message( STATUS "${VAR} [${${VAR}}]")
endmacro()

include(CMakeParseArguments)

set( ECBUILD_GIT  ON  CACHE BOOL "Turn on/off ecbuild_git() function" )

if( ECBUILD_GIT )

  find_package(Git)

  if( NOT ECMWF_USER )
    set( ECMWF_USER $ENV{USER} CACHE STRING "ECMWF git user" )
  endif()

  set( ECMWF_GIT_SSH   "ssh://git@software.ecmwf.int:7999" CACHE STRING "ECMWF ssh address" )
  set( ECMWF_GIT_HTTPS "https://${ECMWF_USER}@software.ecmwf.int/stash/scm" CACHE STRING "ECMWF https address" )

  if( NOT ECMWF_GIT OR ECMWF_GIT MATCHES "[Ss][Ss][Hh]" )
    set( ECMWF_GIT_ADDRESS ${ECMWF_GIT_SSH} CACHE STRING "ECMWF stash" )
  else()
    set( ECMWF_GIT_ADDRESS ${ECMWF_GIT_HTTPS} CACHE STRING "ECMWF stash" )
  endif()
endif()

macro( ecbuild_git )

  set( options NO_HISTORY UPDATE )
  set( single_value_args PROJECT DIR URL TAG BRANCH )
  set( multi_value_args )
  cmake_parse_arguments( _PAR "${options}" "${single_value_args}" "${multi_value_args}" ${_FIRST_ARG} ${ARGN} )

  if( DEFINED _PAR_BRANCH AND DEFINED _PAR_TAG )
    message( FATAL_ERROR "Cannot defined both BRANCH and TAG in macro ecbuild_git" )
  endif()

  if(_PAR_UNPARSED_ARGUMENTS)
    message(FATAL_ERROR "Unknown keywords given to ecbuild_git(): \"${_PAR_UNPARSED_ARGUMENTS}\"")
  endif()

  if( ECBUILD_GIT )

    get_filename_component( _PAR_DIR "${_PAR_DIR}" ABSOLUTE )
    get_filename_component( PARENT_DIR "${_PAR_DIR}/.." ABSOLUTE )

    ### clone if no directory

    if( NOT EXISTS "${_PAR_DIR}" )

      set( clone_args )
      if( DEFINED _PAR_BRANCH )
        set( clone_args -b ${_PAR_BRANCH} )
      endif()
      # default is with history
      if( DEFINED _PAR_NO_HISTORY )
        list( APPEND clone_args --single-branch --depth=1 )
      endif()

      message( STATUS "Cloning ${_PAR_PROJECT} from ${_PAR_URL} into ${_PAR_DIR}...")
      execute_process(
        COMMAND ${GIT_EXECUTABLE} "clone" ${_PAR_URL} ${clone_args} ${_PAR_DIR} ${depth} "-q"
        RESULT_VARIABLE nok ERROR_VARIABLE error
        WORKING_DIRECTORY "${PARENT_DIR}")
      if(nok)
        message(FATAL_ERROR "${_PAR_DIR} git clone failed: ${error}\n")
      endif()
      message( STATUS "${_PAR_DIR} retrieved.")
      set( _PAR_UPDATE TRUE )
    
    endif()

    ### check current tag and sha1

    if( IS_DIRECTORY "${_PAR_DIR}/.git" ) 

        execute_process(
          COMMAND ${GIT_EXECUTABLE} rev-parse HEAD
          OUTPUT_VARIABLE _sha1 RESULT_VARIABLE nok ERROR_VARIABLE error
          WORKING_DIRECTORY "${_PAR_DIR}" )
        if(nok)
          message(STATUS "git rev-parse HEAD of ${_PAR_DIR} failed:\n ${error}")
        endif()

        execute_process(
          COMMAND ${GIT_EXECUTABLE} describe --tags --dirty=-dirty
          OUTPUT_VARIABLE _current_tag RESULT_VARIABLE nok ERROR_VARIABLE error OUTPUT_STRIP_TRAILING_WHITESPACE
          WORKING_DIRECTORY "${_PAR_DIR}" )
        if(nok)
          message(STATUS "git describe --tags --dirty=-dirty of ${_PAR_DIR} failed:\n ${error}")
        endif()

        debug_here( _sha1 )
        debug_here( _current_tag )

    endif()

    if( DEFINED _PAR_BRANCH )

      unset( ${_PAR_PROJECT}_GIT_TAG CACHE )
    
      if( NOT DEFINED ${_PAR_PROJECT}_GIT_BRANCH )
        set( ${_PAR_PROJECT}_GIT_BRANCH ${_PAR_BRANCH} CACHE INTERNAL ""  )
      endif()

      if( NOT "${${_PAR_PROJECT}_GIT_BRANCH}" STREQUAL "${_PAR_BRANCH}" )
        set( ${_PAR_PROJECT}_GIT_BRANCH ${_PAR_BRANCH} CACHE INTERNAL "" )
        set( _PAR_UPDATE TRUE )
      endif()

    endif()

	  if( DEFINED _PAR_TAG )

      unset( ${_PAR_PROJECT}_GIT_BRANCH CACHE )

      set( _PAR_NO_HISTORY FALSE )

      if( NOT DEFINED ${_PAR_PROJECT}_GIT_TAG )
        set( ${_PAR_PROJECT}_GIT_TAG ${_PAR_TAG} CACHE INTERNAL ""  )
      endif()

      if( NOT "${${_PAR_PROJECT}_GIT_TAG}" STREQUAL "${_PAR_TAG}" )
        set( ${_PAR_PROJECT}_GIT_TAG ${_PAR_TAG} CACHE INTERNAL "" )
        set( _PAR_UPDATE TRUE )
      endif()

      if( NOT "${_current_tag}" STREQUAL "${_PAR_TAG}" )
        set( _PAR_UPDATE TRUE )
      endif()

    endif()

    ### updates

    if( _PAR_UPDATE AND IS_DIRECTORY "${_PAR_DIR}/.git" )

      if( DEFINED _PAR_TAG ) #############################################################################

              message(STATUS "Updating ${_PAR_PROJECT} to TAG ${_PAR_TAG}...")

              execute_process(COMMAND "${GIT_EXECUTABLE}" fetch --all -q
                RESULT_VARIABLE nok ERROR_VARIABLE error
                WORKING_DIRECTORY "${_PAR_DIR}")
              if(nok)
                message(STATUS "Update of ${_PAR_DIR} to TAG ${_PAR_TAG} failed:\n ${error}")
              endif()
            
              execute_process(
                COMMAND "${GIT_EXECUTABLE}" checkout -q "${_PAR_TAG}"
                RESULT_VARIABLE nok ERROR_VARIABLE error
                WORKING_DIRECTORY "${_PAR_DIR}"
                )
              if(nok)
                message(FATAL_ERROR "git checkout ${_PAR_TAG} of ${_PAR_DIR} failed: ${error}\n")
              endif()


      else() ####################################################################################

          message(STATUS "Updating ${_PAR_PROJECT} to head of BRANCH ${_PAR_BRANCH}...")

          execute_process(COMMAND "${GIT_EXECUTABLE}" checkout -q "${_PAR_BRANCH}"
            RESULT_VARIABLE nok ERROR_VARIABLE error
            WORKING_DIRECTORY "${_PAR_DIR}")
          if(nok)
            message(STATUS "Checkout of ${_PAR_PROJECT} to branch ${_PAR_BRANCH} failed:\n ${error}")
          endif()
        
          execute_process(COMMAND "${GIT_EXECUTABLE}" pull -q
            RESULT_VARIABLE nok ERROR_VARIABLE error
            WORKING_DIRECTORY "${_PAR_DIR}")
          if(nok)
            message(STATUS "Update of ${_PAR_PROJECT} to branch ${_PAR_BRANCH} failed:\n ${error}")
          endif()
        
      endif() ####################################################################################

    endif( _PAR_UPDATE AND IS_DIRECTORY "${_PAR_DIR}/.git" )

    if( DEFINED _PAR_BRANCH )

      add_custom_target( update_${_PAR_PROJECT}
                         COMMAND "${GIT_EXECUTABLE}" pull -q
                         WORKING_DIRECTORY "${_PAR_DIR}"
                         COMMENT "Updating ${_PAR_PROJECT} to head of BRANCH ${_PAR_BRANCH}" )
      list( APPEND update_targets update_${_PAR_PROJECT} )

    endif()

  endif( ECBUILD_GIT ) 

endmacro()

########################################################################################################################

macro( ecmwf_stash )

  set( options )
  set( single_value_args STASH )
  set( multi_value_args )
  cmake_parse_arguments( _PAR "${options}" "${single_value_args}" "${multi_value_args}" ${_FIRST_ARG} ${ARGN} )

  ecbuild_git( URL "${ECMWF_GIT_ADDRESS}/${_PAR_STASH}.git" ${_PAR_UNPARSED_ARGUMENTS} )

endmacro()

########################################################################################################################

macro( ecbuild_bundle_initialize )

  ecmwf_stash( PROJECT ecbuild DIR ${PROJECT_SOURCE_DIR}/ecbuild   STASH "ecsdk/ecbuild" BRANCH develop )

  list( APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/ecbuild/cmake" )

  include( ecbuild_system )

  ecbuild_requires_macro_version( 1.3 )
  ecbuild_declare_project()

  if( EXISTS "${PROJECT_SOURCE_DIR}/README.md" )
    add_custom_target( ${PROJECT_NAME}_readme SOURCES "${PROJECT_SOURCE_DIR}/README.md" )
  endif()

endmacro()

########################################################################################################################

macro( ecbuild_bundle )

  set( options )
  set( single_value_args PROJECT )
  set( multi_value_args )
  cmake_parse_arguments( _PAR "${options}" "${single_value_args}" "${multi_value_args}" ${_FIRST_ARG} ${ARGN} )
  
  ecmwf_stash( PROJECT ${_PAR_PROJECT} DIR ${PROJECT_SOURCE_DIR}/${_PAR_PROJECT} ${_PAR_UNPARSED_ARGUMENTS} )
  
  ecbuild_use_package( PROJECT ${_PAR_PROJECT} )

endmacro()

macro( ecbuild_bundle_finalize )
  add_custom_target( update
                     DEPENDS ${update_targets} )
  ecbuild_install_project( NAME ${CMAKE_PROJECT_NAME} )
  ecbuild_print_summary()
endmacro()
