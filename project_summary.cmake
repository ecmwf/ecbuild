message( STATUS "---------------------------------------------------------" )

message( STATUS "[Generic]" )

message( STATUS " Perl             : [${PERL_EXECUTABLE}] (${PERL_VERSION})" )

if(PYTHONINTERP_FOUND)
    message( STATUS " Python           : [${PYTHON_EXECUTABLE}] (${PYTHON_VERSION})" )
endif()

if(PYTHONLIBS_FOUND)
    message( STATUS " Python   include : [${PYTHON_INCLUDE_DIRS}]" )
    message( STATUS "          libs    : [${PYTHON_LIBRARIES}]" )
endif()

if(READLINE_FOUND)
    message( STATUS " Readline include : [${READLINE_INCLUDE_DIRS}]" )
    message( STATUS "          libs    : [${READLINE_LIBRARIES}]" )
endif()

if(PNG_FOUND)
    message( STATUS " PNG      include : [${PNG_INCLUDE_DIRS}]" )
    message( STATUS "          libs    : [${PNG_LIBRARY}]" )
endif()

if(JASPER_FOUND)
    message( STATUS " JASPER   include : [${JASPER_INCLUDE_DIR}]" )
    message( STATUS "          libs    : [${JASPER_LIBRARIES}]" )
endif()

if(GRIBAPI_FOUND)
    message( STATUS " GRIB_API  include : [${GRIB_API_INCLUDE_DIRS}]" )
    message( STATUS "          libs    : [${GRIB_API_LIBRARIES}]" )
endif()

if( DEFINED FORTRAN_LIBRARIES )
  message( STATUS "Fortan libs       : [${FORTRAN_LIBRARIES}]" )
endif()

