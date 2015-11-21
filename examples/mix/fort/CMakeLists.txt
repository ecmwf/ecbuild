cmake_minimum_required( VERSION 2.8.4 FATAL_ERROR )

project( bar Fortran )


message( STATUS "CMAKE_Fortran_FLAGS: ${CMAKE_Fortran_FLAGS}" )
message( STATUS "CMAKE_Fortran_FLAGS_DEBUG: ${CMAKE_Fortran_FLAGS_DEBUG}" )


set( SAVE_CMAKE_Fortran_FLAGS       "${CMAKE_Fortran_FLAGS}" )
set( SAVE_CMAKE_Fortran_FLAGS_DEBUG "${CMAKE_Fortran_FLAGS_DEBUG}" )

set( CMAKE_Fortran_FLAGS       "" )
set( CMAKE_Fortran_FLAGS_DEBUG "" )

add_library( bar SHARED bar.f90 )

set_source_files_properties( bar.f90   PROPERTIES COMPILE_FLAGS "-O3" )


set( CMAKE_Fortran_FLAGS       "${SAVE_CMAKE_Fortran_FLAGS}" )
set( CMAKE_Fortran_FLAGS_DEBUG "${SAVE_CMAKE_Fortran_FLAGS_DEBUG}" )

add_library( lolo SHARED lolo.f90 )

set_source_files_properties( lolo.f90  PROPERTIES COMPILE_FLAGS "-pipe" )


message( STATUS "CMAKE_Fortran_FLAGS: ${CMAKE_Fortran_FLAGS}" )
message( STATUS "CMAKE_Fortran_FLAGS_DEBUG: ${CMAKE_Fortran_FLAGS_DEBUG}" )
