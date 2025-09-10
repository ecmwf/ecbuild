cmake_minimum_required( VERSION 3.18 FATAL_ERROR )

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

ecbuild_add_option( FEATURE Y DEFAULT ON )

if( NOT HAVE_Y )
    ecbuild_error( "Feature Y should be enabled, with ENABLE_Y=${ENABLE_Y} as set at bundle level" )
endif()

ecbuild_add_option( FEATURE Z DEFAULT OFF )

if( HAVE_Z )
    ecbuild_error( "Feature Y should be disabled, with ENABLE_Z=${ENABLE_Z} as set at bundle level" )
endif()