message( STATUS "---------------------------------------------------------" )

ecbuild_info( "[Generic]" )

if( PERL_EXECUTABLE )
  ecbuild_info( " Perl             : [${PERL_EXECUTABLE}] (${PERL_VERSION})" )
endif()

if(PYTHONINTERP_FOUND)
  ecbuild_info( " Python           : [${PYTHON_EXECUTABLE}] (${PYTHON_VERSION})" )
endif()

if(PYTHONLIBS_FOUND)
  ecbuild_info( " Python   include : [${PYTHON_INCLUDE_DIRS}]" )
  ecbuild_info( "          libs    : [${PYTHON_LIBRARIES}]" )
endif()

if( DEFINED FORTRAN_LIBRARIES )
  ecbuild_info( "Fortan libs       : [${FORTRAN_LIBRARIES}]" )
endif()

