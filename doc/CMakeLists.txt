# (C) Copyright 2011- ECMWF.
#
# This software is licensed under the terms of the Apache Licence Version 2.0
# which can be obtained at http://www.apache.org/licenses/LICENSE-2.0.
# In applying this licence, ECMWF does not waive the privileges and immunities
# granted to it by virtue of its status as an intergovernmental organisation
# nor does it submit to any jurisdiction.

find_package( PythonInterp )
find_package( Sphinx )

if( PYTHONINTERP_FOUND )

  file( GLOB ECBUILD_MODULE RELATIVE ${CMAKE_CURRENT_SOURCE_DIR}
        ${CMAKE_SOURCE_DIR}/cmake/ecbuild_*.cmake )

  add_custom_target( upload_docs COMMENT "Uploading documentation" )
  add_custom_command( TARGET upload_docs POST_BUILD
                      COMMAND ${PYTHON_EXECUTABLE} upload.py --logfile "${CMAKE_CURRENT_BINARY_DIR}/upload.log" ${ECBUILD_MODULE}
                      WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
                      COMMENT "Uploading documentation" )

  if( SPHINX_FOUND )

    # configured documentation tools and intermediate build results
    set(SPHINX_BUILD_DIR "${CMAKE_CURRENT_BINARY_DIR}/sphinx_build")

    # Sphinx cache with pickled ReST documents
    set(SPHINX_CACHE_DIR "${CMAKE_CURRENT_BINARY_DIR}/sphinx_doctrees")

    # Sphinx source with pickled ReST documents
    set(SPHINX_SOURCE_DIR "${CMAKE_CURRENT_BINARY_DIR}/sphinx_source")

    # HTML output directory
    set(SPHINX_HTML_DIR "${CMAKE_CURRENT_BINARY_DIR}/html")

    add_custom_target( create_docs COMMENT "Creating Sphinx RST documentation" )
    add_custom_command( TARGET create_docs POST_BUILD
        COMMAND ${PYTHON_EXECUTABLE} create.py
                --source ${SPHINX_SOURCE_DIR} ${ECBUILD_MODULE}
        WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
        COMMENT "Creating Sphinx RST documentation" )

    configure_file(
      "${CMAKE_CURRENT_SOURCE_DIR}/conf.py.in"
      "${SPHINX_BUILD_DIR}/conf.py"
      @ONLY)

    add_custom_target(html_docs ALL
          ${SPHINX_EXECUTABLE}
          -q
          -b html
          -c "${SPHINX_BUILD_DIR}"
          -d "${SPHINX_CACHE_DIR}"
          "${SPHINX_SOURCE_DIR}"
          "${SPHINX_HTML_DIR}"
          DEPENDS create_docs
          COMMENT "Building ecBuild HTML documentation with Sphinx")

    install( DIRECTORY ${SPHINX_HTML_DIR} DESTINATION ${INSTALL_DATA_DIR} )

  endif()

endif()
