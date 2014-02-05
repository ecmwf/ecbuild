message( STATUS "---------------------------------------------------------" )

message( STATUS "[Generic]" )

if( PERL_EXECUTABLE )
	message( STATUS " Perl             : [${PERL_EXECUTABLE}] (${PERL_VERSION})" )
endif()

if(PYTHONINTERP_FOUND)
    message( STATUS " Python           : [${PYTHON_EXECUTABLE}] (${PYTHON_VERSION})" )
endif()

if(PYTHONLIBS_FOUND)
    message( STATUS " Python   include : [${PYTHON_INCLUDE_DIRS}]" )
    message( STATUS "          libs    : [${PYTHON_LIBRARIES}]" )
endif()

if( DEFINED FORTRAN_LIBRARIES )
  message( STATUS "Fortan libs       : [${FORTRAN_LIBRARIES}]" )
endif()

