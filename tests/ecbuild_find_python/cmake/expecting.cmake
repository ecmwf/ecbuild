
function( expecting_true )

    set( options )
    set( single_value_args CONDITION )
    set( multi_value_args )
    cmake_parse_arguments( _p "${options}" "${single_value_args}" "${multi_value_args}"  ${_FIRST_ARG} ${ARGN} )

    ecbuild_debug( "Checking if true: ${_p_CONDITION}=${${_p_CONDITION}}" )
    if ( NOT ${${_p_CONDITION}} )
        ecbuild_critical( "Expected condition ${_p_CONDITION} to be true" )
    endif()

endfunction()

function( expecting_false )

    set( options )
    set( single_value_args CONDITION )
    set( multi_value_args )
    cmake_parse_arguments( _p "${options}" "${single_value_args}" "${multi_value_args}"  ${_FIRST_ARG} ${ARGN} )

    ecbuild_debug( "Checking if true: ${_p_CONDITION}=${${_p_CONDITION}}" )
    if ( ${${_p_CONDITION}} )
        ecbuild_critical( "Expected condition ${_p_CONDITION} to be false" )
    endif()

endfunction()


function( expecting_empty )

    set( options )
    set( single_value_args CONDITION )
    set( multi_value_args )
    cmake_parse_arguments( _p "${options}" "${single_value_args}" "${multi_value_args}"  ${_FIRST_ARG} ${ARGN} )

    ecbuild_debug( "Checking if nonempty: ${_p_CONDITION}=${${_p_CONDITION}}" )
    if ( NOT "${${_p_CONDITION}}" STREQUAL "" )
        ecbuild_critical( "Expected condition ${_p_CONDITION} to be a non-empty string" )
    endif()

endfunction()


function( expecting_nonempty )

    set( options )
    set( single_value_args CONDITION )
    set( multi_value_args )
    cmake_parse_arguments( _p "${options}" "${single_value_args}" "${multi_value_args}"  ${_FIRST_ARG} ${ARGN} )

    ecbuild_debug( "Checking if nonempty: ${_p_CONDITION}=${${_p_CONDITION}}" )
    if ( "${${_p_CONDITION}}" STREQUAL "" )
        ecbuild_critical( "Expected condition ${_p_CONDITION} to be a non-empty string" )
    endif()

endfunction()
