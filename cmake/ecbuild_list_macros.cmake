# SPDX-FileCopyrightText: 2011- European Centre for Medium-Range Weather Forecasts (ECMWF)
# SPDX-License-Identifier: Apache-2.0

##############################################################################
# function for concatenating list into a string
#
# examples:
#
#   set( _paths "foo" "bar" )
#   join( _paths "/" _mypath )
#
#   message( "${_mpath}" ) #  produces "foo/bar"

function( JOIN _listname _glue _output )

    set( _ret "" )

    foreach( _v ${${_listname}} )
        if( _ret )
            set(_ret "${_ret}${_glue}${_v}") # append
        else()
            set(_ret "${_v}") # init
        endif()
    endforeach()

    set(${_output} "${_ret}" PARENT_SCOPE)

endfunction()

##############################################################################
# function for inserting a key / value into a map
#
# examples:
#
#   map_insert( "mymap" "foo" "bar" )
#

function( MAP_INSERT _map _key _value )
    set( "_${_map}_${_key}" "${_value}" PARENT_SCOPE )
endfunction(MAP_INSERT)

##############################################################################
# function for inserting a key / value into a map
#
# examples:
#
#   map_get( "mymap" "foo" VAR )
#

function( MAP_GET _map _key _var )
    set( ${_var} "${_${_map}_${_key}}" PARENT_SCOPE )
endfunction(MAP_GET)

