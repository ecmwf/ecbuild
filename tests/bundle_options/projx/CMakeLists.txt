cmake_minimum_required( VERSION 3.18.4 FATAL_ERROR )
find_package( ecbuild 3.4 REQUIRED )

project( projx LANGUAGES NONE VERSION 0.1 )

add_subdirectory( proja )
add_subdirectory( projb )

ecbuild_print_summary()