# (C) Copyright 1996-2015 ECMWF.
#
# This software is licensed under the terms of the Apache Licence Version 2.0
# which can be obtained at http://www.apache.org/licenses/LICENSE-2.0.
# In applying this licence, ECMWF does not waive the privileges and immunities
# granted to it by virtue of its status as an intergovernmental organisation nor
# does it submit to any jurisdiction.

##############################################################################
#.rst:
#
# ecbuild_list_add_pattern
# ========================
#
# Exclude items from a list that match a list of patterns. ::
#
#   ecbuild_list_add_pattern( LIST <input_list>
#                             PATTERNS <pattern1> [ <pattern2> ... ]
#                             [ SOURCE_DIR <source_dir> ]
#                             [ QUIET ] )
#
# Options
# -------
#
# LIST : required
#   list variable to be appended to
#
# PATTERNS : required
#   Regex pattern of exclusions
#
# SOURCE_DIR : optional
#   Directory from where to start search
#
# QUIET  : optional
#   Don't warn if patterns don't match
#
##############################################################################

function( ecbuild_list_add_pattern )

  set( options QUIET )
  set( single_value_args LIST SOURCE_DIR )
  set( multi_value_args  PATTERNS )

  cmake_parse_arguments( _p "${options}" "${single_value_args}" "${multi_value_args}"  ${_FIRST_ARG} ${ARGN} )

  if(_p_UNPARSED_ARGUMENTS)
    message(FATAL_ERROR "Unknown keywords given to ecbuild_list_add_pattern(): \"${_p_UNPARSED_ARGUMENTS}\"")
  endif()

  if( NOT _p_LIST  )
    message(FATAL_ERROR "The call to ecbuild_list_add_pattern() doesn't specify the LIST.")
  endif()

  if( NOT _p_PATTERNS )
    message(FATAL_ERROR "The call to ecbuild_list_add_pattern() doesn't specify the PATTERNS.")
  endif()

  #####

  set( input_list ${${_p_LIST}} )
  unset( matched_files )

  foreach( pattern ${_p_PATTERNS} )

    if( IS_ABSOLUTE ${pattern} )
      ecbuild_debug("pattern ${pattern} is absolute")
      file( GLOB_RECURSE matched_files ${pattern} )
    else()

      if(_p_SOURCE_DIR)
        if( IS_ABSOLUTE ${_p_SOURCE_DIR} )
          ecbuild_debug("source_dir ${_p_SOURCE_DIR} is absolute")
          file( GLOB_RECURSE matched_files ${_p_SOURCE_DIR}/${pattern} )
        else()
          ecbuild_debug("source_dir ${_p_SOURCE_DIR} is relative")
          file( GLOB_RECURSE matched_files RELATIVE ${CMAKE_CURRENT_SOURCE_DIR} ${_p_SOURCE_DIR}/${pattern} )
        endif()
      else()
          file( GLOB_RECURSE matched_files RELATIVE ${CMAKE_CURRENT_SOURCE_DIR} ${pattern} )
      endif()

    endif()

  endforeach()

  if(matched_files)
    list( APPEND input_list ${matched_files} )
    list( REMOVE_DUPLICATES input_list )
    set( ${_p_LIST} ${input_list} PARENT_SCOPE )
  else()
    if(NOT _p_QUIET)
      ecbuild_warn( "ecbuild_list_add_pattern: no matches found for patterns ${_p_PATTERNS}" )
    endif()
  endif()

endfunction(ecbuild_list_add_pattern)
