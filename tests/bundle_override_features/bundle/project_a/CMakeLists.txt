cmake_minimum_required( VERSION 3.11 FATAL_ERROR )

find_package( ecbuild REQUIRED )

project( project_a VERSION 0.0.0 LANGUAGES C )

if( HAVE_TESTS )
    ecbuild_error( "Tests should be disabled, as PROJECT_A_ENABLE_TESTS=${PROJECT_A_ENABLE_TESTS},"
                   " even though ENABLE_TESTS=${ENABLE_TESTS}" )
endif()

if( DEFINED ENABLE_X )
    if( NOT _configured_before )
        ecbuild_error( "This test is designed to have ENABLE_X undefined (upon first run at least)" )
        set( _configured_before TRUE CACHE BOOL INTERNAL )
    endif()
endif()

ecbuild_add_option( FEATURE X DEFAULT ON )

if( NOT HAVE_X )
    ecbuild_error( "Feature X should be default-enabled as ENABLE_X is undefined" )
endif()