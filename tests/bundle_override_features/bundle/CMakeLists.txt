cmake_minimum_required( VERSION 3.11 FATAL_ERROR )

find_package( ecbuild REQUIRED )

set( ENABLE_TESTS ON CACHE BOOL "" )
set( PROJECT_A_ENABLE_TESTS OFF CACHE BOOL "" )

set( PROJECT_B_ENABLE_X OFF CACHE BOOL "" )

project( bundle VERSION 0.0.0 LANGUAGES C )

add_subdirectory( project_a )
add_subdirectory( project_b )

