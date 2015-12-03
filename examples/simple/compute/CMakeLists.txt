if( HAVE_MATRIX )
    set( compute_defs HAVE_MATRIX_LAPACK )
else()
    set( compute_defs "" )
endif()

ecbuild_add_executable(

    TARGET
        compute

    SOURCES
        compute.cc

    DEFINITIONS
        ${compute_defs}

    INCLUDES
        ${GSL_INCLUDE_DIRS}

    LIBS
        circle
        ${LAPACK_LIBRARIES}
        ${GSL_LIBRARIES}
)
