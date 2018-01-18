# (C) Copyright 1996 ECMWF.
#
# This software is licensed under the terms of the Apache Licence Version 2.0
# which can be obtained at http://www.apache.org/licenses/LICENSE-2.0.
# In applying this licence, ECMWF does not waive the privileges and immunities
# granted to it by virtue of its status as an intergovernmental organisation
# nor does it submit to any jurisdiction.

find_package( PythonInterp )

if( PYTHONINTERP_FOUND )

  file( GLOB ECBUILD_MODULE RELATIVE ${CMAKE_CURRENT_SOURCE_DIR}
        ${CMAKE_SOURCE_DIR}/cmake/ecbuild_*.cmake )

  add_custom_target( upload_docs COMMENT "Uploading documentation" )
  add_custom_command( TARGET upload_docs POST_BUILD
                      COMMAND ${PYTHON_EXECUTABLE} upload.py --logfile "${CMAKE_CURRENT_BINARY_DIR}/upload.log" ${ECBUILD_MODULE}
                      WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
                      COMMENT "Uploading documentation" )

endif()
