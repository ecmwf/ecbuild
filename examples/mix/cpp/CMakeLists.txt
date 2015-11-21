cmake_minimum_required( VERSION 2.8.4 FATAL_ERROR )

project( foo CXX )

set( CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -dynamic" )

add_executable( foo main.cxx )

target_link_libraries( foo ${CMAKE_SOURCE_DIR}/../bar/build/libbar.so )
