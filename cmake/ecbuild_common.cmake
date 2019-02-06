# (C) Copyright 2018- ECMWF.
#
# This software is licensed under the terms of the Apache Licence Version 2.0
# which can be obtained at http://www.apache.org/licenses/LICENSE-2.0.
# In applying this licence, ECMWF does not waive the privileges and immunities
# granted to it by virtue of its status as an intergovernmental organisation nor
# does it submit to any jurisdiction.


##############################################################################
#.rst:
#
# ecbuild_evaluateCondition
# ==================
#
# Add a CMake configuration option, which may depend on a list of packages. ::
#
#   ecbuild_evaluateCondition( condition outVariable )
#
# Options
# -------
# condition A list of boolean statements like OPENSSL_FOUND AND ENABLE_OPENSSL
#
function(ecbuild_evaluateCondition _conditions _outVar)
  if( DEFINED ${_conditions})
    if(${${_conditions}})
      set( ${_outVar} TRUE PARENT_SCOPE )
    else()
      set( ${_outVar} FALSE PARENT_SCOPE )
    endif()
  else()
    set( ${_outVar} TRUE PARENT_SCOPE )
  endif()
  ecbuild_debug("ecbuild_evaluateCondition(${_outVar}): checking condition '${${_conditions}}' -> ${${_outVar}}")
endfunction()


##############################################################################
#.rst:
#
# ecbuild_filter_list
# ===================
#
# Filters a list for NOTFOUND entries and non existing TARGETS. ::
#
#   ecbuild_filter_list( [INCLUDES] [LIBS]
#                        LIST <list>
#                        [LIST_INCLUDE <output_list>]
#                        [LIST_EXCLUDE <output_list>])
#
# Options
# -------
#
# INCLUDES : optional
#   Consider existing dirs as valid
#
# LIBS : optional
#   Consider existing targets, files and compile flags as valid
#
# LIST : required
#   a list
#
# LIST_INCLUDE : optional
#   The output list with all valid entries of LIST
#
# LIST_EXCLUDE : optional
#   The output list with all invalid entries of LIST
#

##############################################################################

function(ecbuild_filter_list)
    set(options           INCLUDES LIBS)
    set(single_value_args LIST_INCLUDE LIST_EXCLUDE)
    set(multi_value_args  LIST)

    cmake_parse_arguments(_PAR "${options}" "${single_value_args}" "${multi_value_args}" ${ARGN})

    set(__listIn ${_PAR_LIST})
    set(__listOut)
    set(__listOutSkip)

    list(REMOVE_DUPLICATES __listIn)
    foreach(lib ${__listIn})
        if(_PAR_INCLUDES AND IS_DIRECTORY "${lib}")
            list(APPEND __listOut ${lib})
        elseif(_PAR_LIBS AND TARGET "${lib}")
            list(APPEND __listOut ${lib})
        elseif(_PAR_LIBS AND "${lib}" MATCHES "^-")
            list(APPEND __listOut ${lib})
        elseif(_PAR_LIBS AND EXISTS "${lib}")
            list(APPEND __listOut ${lib})
        elseif("${lib}")
            list(APPEND __listOut ${lib})
        else()
            list(APPEND __listOutSkip ${lib})
        endif()
    endforeach()
    if(_PAR_LIST_INCLUDE)
        set(${_PAR_LIST_INCLUDE} ${__listOut} PARENT_SCOPE)
    endif()
    if(_PAR_LIST_EXCLUDE)
        set(${_PAR_LIST_EXCLUDE} ${__listOutSkip} PARENT_SCOPE)
    endif()
endfunction()
