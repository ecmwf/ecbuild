# (C) Copyright 1996-2012 ECMWF.
# 
# This software is licensed under the terms of the Apache Licence Version 2.0
# which can be obtained at http://www.apache.org/licenses/LICENSE-2.0. 
# In applying this licence, ECMWF does not waive the privileges and immunities 
# granted to it by virtue of its status as an intergovernmental organisation nor
# does it submit to any jurisdiction.

##############################################################################
# macro for adding persistent layer object classes
##############################################################################

macro( debug_var VAR )

    message( STATUS "${VAR} [${${VAR}}]" )

endmacro( debug_var )


##############################################################################
# macro that only adds a c flag if compiler supports it

macro( cmake_add_c_flags m_c_flags )

  if( NOT DEFINED N_CFLAG )
    set( N_CFLAG 0 )
  endif()

  math( EXPR N_CFLAG '${N_CFLAG}+1' )

  check_c_compiler_flag( ${m_c_flags} C_FLAG_TEST_${N_CFLAG} )

  if( C_FLAG_TEST_${N_CFLAG} )
    set( CMAKE_C_FLAGS "${CMAKE_C_FLAGS} ${m_c_flags}" )
    message( STATUS "C FLAG [${m_c_flags}] added" )
  else()
    message( STATUS "C FLAG [${m_c_flags}] skipped" )
  endif()

endmacro()

##############################################################################
# macro that only adds a cxx flag if compiler supports it

macro( cmake_add_cxx_flags m_cxx_flags )

  if( NOT DEFINED N_CXXFLAG )
    set( N_CXXFLAG 0 )
  endif()

  math( EXPR N_CXXFLAG '${N_CXXFLAG}+1' )

  check_cxx_compiler_flag( ${m_cxx_flags} CXX_FLAG_TEST_${N_CXXFLAG} )

  if( CXX_FLAG_TEST_${N_CXXFLAG} )
    set( CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${m_cxx_flags}" )
    message( STATUS "C++ FLAG [${m_cxx_flags}] added" )
  else()
    message( STATUS "C++ FLAG [${m_cxx_flags}] skipped" )
  endif()

endmacro()
