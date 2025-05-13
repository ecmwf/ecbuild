cmake_minimum_required( VERSION 3.18 FATAL_ERROR )

find_package( ecbuild REQUIRED )

project( project_b VERSION 0.0.0 LANGUAGES C )

if( NOT HAVE_TESTS )
    ecbuild_error( "Tests should be enabled" )
endif()

# ENABLE_X was already defined and cached in project_a
if( NOT ENABLE_X )
    ecbuild_error( "This test is designed to have ENABLE_X=OFF" )
endif()

if( NOT DEFINED PROJECT_B_ENABLE_X )
    ecbuild_error( "This test is designed to have PROJECT_B_ENABLE_X=OFF" )
endif()

ecbuild_add_option( FEATURE X DEFAULT ON )

if( HAVE_X )
    ecbuild_error( "Feature X should be disabled, as PROJECT_B_ENABLE_X=${PROJECT_B_ENABLE_X},"
                   " even though ENABLE_X=OFF" )
endif()
