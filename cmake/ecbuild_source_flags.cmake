# (C) Copyright 1996-2015 ECMWF.
#
# This software is licensed under the terms of the Apache Licence Version 2.0
# which can be obtained at http://www.apache.org/licenses/LICENSE-2.0.
# In applying this licence, ECMWF does not waive the privileges and immunities
# granted to it by virtue of its status as an intergovernmental organisation
# nor does it submit to any jurisdiction.

set( __gen_source_flags ${CMAKE_CURRENT_LIST_DIR}/gen_source_flags.py )

# Calls gen_source_flags.py to generate a CMake file with the per
# source file flags for a given target.
function( ecbuild_source_flags OUT TARGET DEFAULT_FLAGS SOURCES )

  debug_var( OUT )
  debug_var( TARGET )
  debug_var( DEFAULT_FLAGS )
  debug_var( SOURCES )

  if( NOT PYTHONINTERP_FOUND OR PYTHON_VERSION VERSION_LESS 2.7 )
    ecbuild_find_python( VERSION 2.7 REQUIRED )
  endif()

  set( OUTFILE ${CMAKE_CURRENT_BINARY_DIR}/${TARGET}_source_flags.cmake )

  # add_custom_command( OUTPUT ${OUTFILE} VERBATIM
  #                     COMMAND ${PYTHON_EXECUTABLE} ${__gen_source_flags}
  #                       ${ECBUILD_SOURCE_FLAGS} ${OUTFILE}} ${DEFAULT_FLAGS} ${SOURCES}
  #                     COMMENT "Generating source flags for target ${TARGET}"
  #                     DEPENDS ${__gen_source_flags} ${ECBUILD_SOURCE_FLAGS} )
  # add_custom_target( ${TARGET}_source_flags ALL DEPENDS ${OUTFILE})

  execute_process( COMMAND ${PYTHON_EXECUTABLE}
    ${__gen_source_flags} ${ECBUILD_SOURCE_FLAGS} ${OUTFILE} "${DEFAULT_FLAGS}" ${SOURCES} )

  set( ${OUT} ${OUTFILE} PARENT_SCOPE )

endfunction()
