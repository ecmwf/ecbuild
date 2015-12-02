if( HAVE_BESSEL )
    set( compute_defs HAVE_GSL )
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
        ${GSL_LIBRARIES}
)

ecbuild_info(${GSL_LIBRARIES})