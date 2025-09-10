cmake_minimum_required( VERSION 3.18 FATAL_ERROR )
find_package( ecbuild 3.4 REQUIRED )

project( main LANGUAGES NONE VERSION 0.1 )

add_subdirectory( proja )
add_subdirectory( projb )
add_subdirectory( projc )

ecbuild_print_summary()