if( HAVE_MATRIX )
    set( compute_defs HAVE_MATRIX_LAPACK )
endif()

ecbuild_add_executable(

    TARGET
        compute

    SOURCES
        compute.cc

    DEFINITIONS
        "${compute_defs}"

    LIBS
        circle
)
if( GSL_FOUND )
    target_compile_definitions(compute PRIVATE HAVE_GSL)
    target_include_directories(compute PRIVATE ${GSL_INCLUDE_DIRS})
    target_link_libraries(compute ${GSL_LIBRARIES})
endif()
if( LAPACK_FOUND )
    target_link_libraries(compute ${LAPACK_LIBRARIES})
endif()
