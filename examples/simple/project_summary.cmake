message( STATUS "---------------------------------------------------------" )

if( LAPACK_FOUND )
    ecbuild_info( " LAPACK : [${LAPACK_LIBRARIES}]" )
endif()

if( GSL_FOUND )
    ecbuild_info( " GSL include : [${GSL_INCLUDE_DIRS}]" )
    ecbuild_info( "     libs    : [${GSL_LIBRARIES}]" )
endif()

