find_package( PythonInterp )

if( PYTHONINTERP_FOUND )

  if( DEFINED ENV{CONFLUENCE_PASSWORD} )

    file( GLOB ECBUILD_MODULE RELATIVE ${CMAKE_CURRENT_SOURCE_DIR}
          ${CMAKE_SOURCE_DIR}/cmake/ecbuild_*.cmake )

    add_custom_target( upload_docs COMMENT "Uploading documentation" )
    add_custom_command( TARGET upload_docs POST_BUILD
                        COMMAND ${PYTHON_EXECUTABLE} upload.py --logfile "${CMAKE_CURRENT_BINARY_DIR}/upload.log" ${ECBUILD_MODULE}
                        WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
                        COMMENT "Uploading documentation" )

  else()

    add_custom_target( upload_docs COMMENT "Failed to upload documentation: the Confluence password must be exported as environment variable CONFLUENCE_PASSWORD" )

  endif()

endif()
