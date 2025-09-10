cmake_minimum_required( VERSION 3.18 FATAL_ERROR )

project( mybundle VERSION 0.1.0.0 LANGUAGES NONE )

add_subdirectory( ecbuild )
add_subdirectory( mylib )

find_package( mylib REQUIRED )

if( NOT mylib_found_using_find_package )

  # This variable is defined within the export files that are only called during find_package()
  message( FATAL_ERROR "The variable mylib_found_using_find_package is not set" )
endif()

message( "mylib has been found successfully within a standard CMake project" )
