cmake_minimum_required( VERSION 3.18 FATAL_ERROR )
find_package( ecbuild 3.4 REQUIRED )

project( project LANGUAGES NONE VERSION 0.2 )

ecbuild_find_python( VERSION 3.999)

include(${CMAKE_SOURCE_DIR}/../cmake/expecting.cmake)

expecting_false( CONDITION PYTHON_FOUND )

expecting_false( CONDITION Python_FOUND )
