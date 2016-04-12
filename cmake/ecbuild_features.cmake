# (C) Copyright 1996-2016 ECMWF.
#
# This software is licensed under the terms of the Apache Licence Version 2.0
# which can be obtained at http://www.apache.org/licenses/LICENSE-2.0.
# In applying this licence, ECMWF does not waive the privileges and immunities
# granted to it by virtue of its status as an intergovernmental organisation
# nor does it submit to any jurisdiction.

# Internal macros to handle CMake features

include( FeatureSummary )

# Write list of enabled features to CMake variable ${OUT}
macro( ecbuild_enabled_features OUT )
    get_property( ${OUT}  GLOBAL PROPERTY ENABLED_FEATURES )
endmacro()

# Write list of disabled features to CMake variable ${OUT}
macro( ecbuild_disabled_features OUT )
    get_property( ${OUT}  GLOBAL PROPERTY DISABLED_FEATURES )
endmacro()

# Enable the feature ${_name} (add to enabled features, remove from disabled)
function( ecbuild_enable_feature _name )

  get_property( _enabled_features  GLOBAL PROPERTY ENABLED_FEATURES )
  get_property( _disabled_features GLOBAL PROPERTY DISABLED_FEATURES )

  if( _disabled_features )
    list( REMOVE_ITEM _disabled_features ${_name} )
  endif()

  list( APPEND _enabled_features ${_name} )
  list( REMOVE_DUPLICATES _enabled_features )

  set_property(GLOBAL PROPERTY ENABLED_FEATURES  "${_enabled_features}" )
  set_property(GLOBAL PROPERTY DISABLED_FEATURES "${_disabled_features}" )

endfunction()

# Disable the feature ${_name} (add to disabled features, remove from enabled)
function( ecbuild_disable_feature _name )

  get_property( _enabled_features  GLOBAL PROPERTY ENABLED_FEATURES )
  get_property( _disabled_features GLOBAL PROPERTY DISABLED_FEATURES )

  if( _enabled_features )
    list( REMOVE_ITEM _enabled_features ${_name} )
  endif()

  list( APPEND _disabled_features ${_name} )
  list( REMOVE_DUPLICATES _disabled_features )

  set_property(GLOBAL PROPERTY ENABLED_FEATURES  "${_enabled_features}" )
  set_property(GLOBAL PROPERTY DISABLED_FEATURES "${_disabled_features}" )

endfunction()

# en/disable feature ${_name} and set its description and purpose
function( ecbuild_set_feature _name )

  set(options ) # none
  set(oneValueArgs ENABLED )
  set(multiValueArgs ) # none

  cmake_parse_arguments( _PAR "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN} )

  get_property( _feature_desc      GLOBAL PROPERTY _CMAKE_${_name}_DESCRIPTION )
  get_property( _enabled_features  GLOBAL PROPERTY ENABLED_FEATURES )
  get_property( _disabled_features GLOBAL PROPERTY DISABLED_FEATURES )

  if( DEFINED _PAR_ENABLED )
    if( _PAR_ENABLED )
      ecbuild_debug( "ecbuild_set_feature(${_name}): enabling feature" )
      ecbuild_enable_feature( ${_name} )
    else()
      ecbuild_debug( "ecbuild_set_feature(${_name}): disabling feature" )
      ecbuild_disable_feature( ${_name} )
    endif()
  endif()

  ecbuild_enabled_features( _enabled_features )
  list (FIND _enabled_features "${_name}" _index)
  if (${_index} GREATER -1)
    set( _feature_found 1 )
  endif()

  ecbuild_disabled_features( _disabled_features )
  list (FIND _disabled_features "${_name}" _index)
  if (${_index} GREATER -1)
    set( _feature_found 1 )
  endif()

  if( NOT _feature_found )
    ecbuild_warn( "Feature ${_name} has not yet been enabled or disabled" )
  endif()

endfunction()
