#=============================================================================
# CMake - Cross Platform Makefile Generator
# Copyright 2000-2013 Kitware, Inc., Insight Software Consortium
#
# Distributed under the OSI-approved BSD License (the "License");
# see accompanying file Copyright.txt for details.
#
# This software is distributed WITHOUT ANY WARRANTY; without even the
# implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
# See the License for more information.
#=============================================================================
option(SPHINX_MAN "Build man pages with Sphinx" OFF)
option(SPHINX_HTML "Build html help with Sphinx" OFF)
option(SPHINX_SINGLEHTML "Build html single page help with Sphinx" OFF)
option(SPHINX_QTHELP "Build Qt help with Sphinx" OFF)
option(SPHINX_TEXT "Build text help with Sphinx (not installed)" OFF)
find_program(SPHINX_EXECUTABLE
  NAMES sphinx-build
  DOC "Sphinx Documentation Builder (sphinx-doc.org)"
  )
set(SPHINX_FLAGS "" CACHE STRING "Flags to pass to sphinx-build")
separate_arguments(sphinx_flags UNIX_COMMAND "${SPHINX_FLAGS}")

mark_as_advanced(SPHINX_TEXT)
mark_as_advanced(SPHINX_FLAGS)

if(NOT SPHINX_MAN AND NOT SPHINX_HTML AND NOT SPHINX_SINGLEHTML AND NOT SPHINX_QTHELP AND NOT SPHINX_TEXT)
  return()
elseif(NOT SPHINX_EXECUTABLE)
  message(FATAL_ERROR "SPHINX_EXECUTABLE (sphinx-build) is not found!")
endif()

set(doc_formats "")
if(SPHINX_HTML)
  list(APPEND doc_formats html)
endif()
if(SPHINX_MAN)
  list(APPEND doc_formats man)
endif()
if(SPHINX_SINGLEHTML)
  list(APPEND doc_formats singlehtml)
endif()
if(SPHINX_TEXT)
  list(APPEND doc_formats text)
endif()
if(SPHINX_QTHELP)
  find_package(PythonInterp REQUIRED)

  find_program(QCOLLECTIONGENERATOR_EXECUTABLE
    NAMES qcollectiongenerator
    DOC "qcollectiongenerator tool"
    )
  if (NOT QCOLLECTIONGENERATOR_EXECUTABLE)
    message(FATAL_ERROR "QCOLLECTIONGENERATOR_EXECUTABLE (qcollectiongenerator) not found!")
  endif()
  list(APPEND doc_formats qthelp)

  set(qthelp_extra_commands
    # Workaround for assistant prior to
    # https://codereview.qt-project.org/#change,82250 in Qt 4.
    COMMAND ${CMAKE_COMMAND} "-DCSS_DIR=${CMAKE_CURRENT_BINARY_DIR}/qthelp/_static"
      -P "${CMAKE_CURRENT_SOURCE_DIR}/apply_qthelp_css_workaround.cmake"
    # Workaround sphinx configurability:
    # https://bitbucket.org/birkenfeld/sphinx/issue/1448/make-qthelp-more-configurable
    COMMAND ${CMAKE_COMMAND} "-DQTHELP_DIR=${CMAKE_CURRENT_BINARY_DIR}/qthelp/"
      "-DCMake_VERSION=${CMake_VERSION_MAJOR}${CMake_VERSION_MINOR}${CMake_VERSION_PATCH}"
      -P "${CMAKE_CURRENT_SOURCE_DIR}/fixup_qthelp_names.cmake"

    # Create proper identifiers. Workaround for
    # https://bitbucket.org/birkenfeld/sphinx/issue/1491/qthelp-should-generate-identifiers-for
    COMMAND "${PYTHON_EXECUTABLE}"
      "${CMAKE_CURRENT_SOURCE_DIR}/create_identifiers.py"
      "${CMAKE_CURRENT_BINARY_DIR}/qthelp/"

    COMMAND ${QCOLLECTIONGENERATOR_EXECUTABLE}
      ${CMAKE_CURRENT_BINARY_DIR}/qthelp/CMake.qhcp
  )
endif()


set(doc_format_outputs "")
set(doc_format_last "")
foreach(format ${doc_formats})
  set(doc_format_output "doc_format_${format}")
  set(doc_format_log "build-${format}.log")
  add_custom_command(
    OUTPUT ${doc_format_output}
    COMMAND ${SPHINX_EXECUTABLE}
            -c ${CMAKE_CURRENT_SOURCE_DIR}
            -d ${CMAKE_CURRENT_BINARY_DIR}/doctrees
            -b ${format}
            ${sphinx_flags}
            ${CMAKE_CURRENT_SOURCE_DIR}
            ${CMAKE_CURRENT_BINARY_DIR}/${format}
            > ${doc_format_log} # log stdout, pass stderr
    ${${format}_extra_commands}
    DEPENDS ${doc_format_last}
    COMMENT "sphinx-build ${format}: see doc/${doc_format_log}"
    VERBATIM
    )
  set_property(SOURCE ${doc_format_output} PROPERTY SYMBOLIC 1)
  list(APPEND doc_format_outputs ${doc_format_output})
  set(doc_format_last ${doc_format_output})
endforeach()

add_custom_target(documentation ALL DEPENDS ${doc_format_outputs})

# ----------------------------------------------------------------------------

find_package( PythonInterp )

if( PYTHONINTERP_FOUND )

  # Generate documentation

  add_custom_target( generate_docs COMMENT "Generating documentation" )
  add_custom_command( TARGET generate_docs POST_BUILD
                      COMMAND ${PYTHON_EXECUTABLE} generate.py ${CMAKE_SOURCE_DIR}/cmake
                      WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR} )

  # Upload documentation

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
