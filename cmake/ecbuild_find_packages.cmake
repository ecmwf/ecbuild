# (C) Copyright 1996-2012 ECMWF.
# 
# This software is licensed under the terms of the Apache Licence Version 2.0
# which can be obtained at http://www.apache.org/licenses/LICENSE-2.0. 
# In applying this licence, ECMWF does not waive the privileges and immunities 
# granted to it by virtue of its status as an intergovernmental organisation nor
# does it submit to any jurisdiction.

############################################################################################
# find external packages

# perl

find_package( Perl REQUIRED )

execute_process( COMMAND ${PERL_EXECUTABLE} -V:version OUTPUT_VARIABLE  perl_version_output_variable  RESULT_VARIABLE  perl_version_return )
if( NOT perl_version_return )
    string(REGEX REPLACE "version='([^']+)'.*" "\\1" PERL_VERSION ${perl_version_output_variable})
endif()

# find preferably bison or else yacc

if( NOT SKIP_BISON )

    find_package( BISON 2.3 )
    find_package( FLEX )

endif()

if( NOT BISON_FOUND AND NOT SKIP_YACC )

    find_package( YACC )
    find_package( LEX  )

endif()

if( NOT YACC_FOUND AND NOT BISON_FOUND ) # neither bison nor yacc were found
    message( FATAL_ERROR "neither bison or yacc were found - at least one is required (together with its lexical analyser" )
endif()

if( NOT YACC_FOUND ) # check for both bison & flex together
    if( BISON_FOUND AND NOT FLEX_FOUND )
        message( FATAL_ERROR "both bison and flex are required - flex not found" )
    endif()
    if( FLEX_FOUND AND NOT BISON_FOUND )
        message( FATAL_ERROR "both bison and flex are required - bison not found" )
    endif()
endif()

if( NOT BISON_FOUND ) # check for both yacc & lex together
    if( YACC_FOUND AND NOT LEX_FOUND )
        message( FATAL_ERROR "both yacc and lex are required - lex not found" )
    endif()
    if( LEX_FOUND AND NOT YACC_FOUND )
        message( FATAL_ERROR "both yacc and lex are required - yacc not found" )
    endif()
endif()

# find ncurses
find_package( Curses  REQUIRED )

# find rt when on Linux - other UNIX's have async io in the system library
if( CMAKE_SYSTEM_NAME MATCHES "Linux" )
    find_package( Realtime REQUIRED )
endif()

# find thread library, but prefer pthreads
set( CMAKE_THREAD_PREFER_PTHREAD 1 )
find_package(Threads REQUIRED)
if( NOT ${CMAKE_USE_PTHREADS_INIT} )
    message( FATAL_ERROR "Mars only supports pthreads - thread library found is [${CMAKE_THREAD_LIBS_INIT}]" )
endif()

###########################################################################################
# fortran static link libraries

if( WITH_PGI_FORTRAN OR DEFINED PGI_PATH )
    find_package(PGIFortran)
    if( PGIFORTRAN_LIBRARIES )
        set( FORTRAN_LIBRARIES ${PGIFORTRAN_LIBRARIES} )
    endif()
endif()

if( WITH_XL_FORTRAN OR DEFINED XLF_PATH )
    find_package(XLFortranLibs)
    if( XLFORTRAN_LIBRARIES )
        set( FORTRAN_LIBRARIES ${XLFORTRAN_LIBRARIES} )
    endif()
endif()

if( WITH_LIBGFORTRAN OR DEFINED LIBGFORTRAN_PATH )
    find_package(LibGFortran)
    if( LIBGFORTRAN_LIBRARIES )
        set( FORTRAN_LIBRARIES ${LIBGFORTRAN_LIBRARIES} )
    endif()
endif()

