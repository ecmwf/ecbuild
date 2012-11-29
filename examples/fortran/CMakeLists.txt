cmake_minimum_required( VERSION 2.6.4 FATAL_ERROR )

project( compute_circle Fortran )

############################################################

add_library( const STATIC constants.f90 )

############################################################

# file( GLOB area_srcs RELATIVE ${CMAKE_CURRENT_SOURCE_DIR} "*circle.f90" )

add_library( area_circle SHARED ${area_srcs} )

target_link_libraries( area_circle const )

############################################################

add_executable( compute_circle main.F90 )

target_link_libraries( compute_circle area_circle )