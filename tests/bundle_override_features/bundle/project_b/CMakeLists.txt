cmake_minimum_required( VERSION 3.18 FATAL_ERROR )

find_package( ecbuild REQUIRED )

project( project_b VERSION 0.0.0 LANGUAGES C )

if( NOT HAVE_TESTS )
    ecbuild_error( "Tests should be enabled" )
endif()

if( NOT DEFINED PROJECT_B_ENABLE_X )
    ecbuild_error( "This test is designed to have PROJECT_B_ENABLE_X=OFF" )
endif()

ecbuild_add_option( FEATURE X DEFAULT ON )

if( HAVE_X )
    ecbuild_error( "Feature X should be disabled, as PROJECT_B_ENABLE_X=${PROJECT_B_ENABLE_X},"
                   " even though ENABLE_X=OFF" )
endif()

ecbuild_add_option( FEATURE Y DEFAULT OFF )

if( NOT HAVE_Y )
    ecbuild_error( "Feature Y should be enabled, as ENABLE_Y=${ENABLE_Y} as set at bundle level" )
endif()

ecbuild_add_option( FEATURE Z DEFAULT OFF )

if( HAVE_Z )
    ecbuild_error( "Feature Y should be disabled, with ENABLE_Z=${ENABLE_Z} as set at bundle level" )
endif()