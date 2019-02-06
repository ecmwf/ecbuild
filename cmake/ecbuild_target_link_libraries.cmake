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
# ecbuild_target_link_libraries
# ===================
#
# Link a target with another, similar to target_link_libraries.
# In difference to target_link_libraries targets are not required to exist.::
#
#   ecbuild_target_link_libraries( <name>
#                                  [ PUBLIC <target1> <target2> <target3> ... ]
#                                  [ PRIVATE <target1> <target2> <target3> ... ])
#
#
# Options
# -------
# PRIVATE: optional
#   list of targets, for the private interface
#
# PUBLIC: optional
#   list of targets, for the public interface

function(ecbuild_target_link_libraries _PAR_TARGET)
  set( options           )
  set( single_value_args )
  set( multi_value_args  PUBLIC PRIVATE )
  cmake_parse_arguments(_PAR "${options}" "${single_value_args}" "${multi_value_args}" ${ARGN})

  ecbuild_filter_list(LIBS LIST ${_PAR_PUBLIC} LIST_INCLUDE _PAR_PUBLIC LIST_EXCLUDE _public_removed)
  ecbuild_filter_list(LIBS LIST ${_PAR_PRIVATE} LIST_INCLUDE _PAR_PRIVATE LIST_EXCLUDE _private_removed)

  target_link_libraries(${_PAR_TARGET} PUBLIC ${_PAR_PUBLIC} PRIVATE ${_PAR_PRIVATE})
endfunction()
