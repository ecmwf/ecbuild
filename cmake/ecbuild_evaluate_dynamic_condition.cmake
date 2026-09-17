# SPDX-FileCopyrightText: 2011- European Centre for Medium-Range Weather Forecasts (ECMWF)
# SPDX-License-Identifier: Apache-2.0

##############################################################################
#.rst:
#
# ecbuild_evaluate_dynamic_condition
# ==================================
#
# Add a CMake configuration option, which may depend on a list of packages. ::
#
#   ecbuild_evaluate_dynamic_condition( condition outVariable )
#
# Options
# -------
# condition A list of boolean statements like OPENSSL_FOUND AND ENABLE_OPENSSL
#
function(ecbuild_evaluate_dynamic_condition _conditions _outVar)
  if( DEFINED ${_conditions})
    if(${${_conditions}})
      set( ${_outVar} TRUE )
    else()
      set( ${_outVar} FALSE )
    endif()
  else()
    set( ${_outVar} TRUE )
  endif()
  ecbuild_debug("ecbuild_evaluate_dynamic_condition(${_outVar}): checking condition '${${_conditions}}' -> ${${_outVar}}")
  set( ${_outVar} ${${_outVar}} PARENT_SCOPE )
endfunction()
