# (C) Copyright 2011- ECMWF.
#
# This software is licensed under the terms of the Apache Licence Version 2.0
# which can be obtained at http://www.apache.org/licenses/LICENSE-2.0.
# In applying this licence, ECMWF does not waive the privileges and immunities
# granted to it by virtue of its status as an intergovernmental organisation nor
# does it submit to any jurisdiction.

##############################################################################
#.rst:
#
# ecbuild_add_executable
# ======================
#
# Add an executable with a given list of source files. ::
#
#   ecbuild_add_executable( TARGET <name>
#                           SOURCES <source1> [<source2> ...]
#                           [ SOURCES_GLOB <glob1> [<glob2> ...] ]
#                           [ SOURCES_EXCLUDE_REGEX <regex1> [<regex2> ...] ]
#                           [ OBJECTS <obj1> [<obj2> ...] ]
#                           [ TEMPLATES <template1> [<template2> ...] ]
#                           [ LIBS <library1> [<library2> ...] ]
#                           [ NO_AS_NEEDED ]
#                           [ INCLUDES <path1> [<path2> ...] ]
#                           [ DEFINITIONS <definition1> [<definition2> ...] ]
#                           [ PERSISTENT <file1> [<file2> ...] ]
#                           [ GENERATED <file1> [<file2> ...] ]
#                           [ DEPENDS <target1> [<target2> ...] ]
#                           [ CONDITION <condition> ]
#                           [ PROPERTIES <prop1> <val1> [<prop2> <val2> ...] ]
#                           [ NOINSTALL ]
#                           [ VERSION <version> | AUTO_VERSION ]
#                           [ CFLAGS <flag1> [<flag2> ...] ]
#                           [ CXXFLAGS <flag1> [<flag2> ...] ]
#                           [ FFLAGS <flag1> [<flag2> ...] ]
#                           [ LINKER_LANGUAGE <lang> ]
#                           [ OUTPUT_NAME <name> ] )
#
# Options
# -------
#
# TARGET : required
#   target name
#
# SOURCES : required
#   list of source files
#
# SOURCES_GLOB : optional
#   search pattern to find source files to compile (note: not recommend according to CMake guidelines)
#   it is usually better to explicitly list the source files in the CMakeList.txt
#
# SOURCES_EXCLUDE_REGEX : optional
#   search pattern to exclude source files from compilation, applies o the results of SOURCES_GLOB
#
# OBJECTS : optional
#   list of object libraries to add to this target
#
# TEMPLATES : optional
#   list of files specified as SOURCES which are not to be compiled separately
#   (these are commonly template implementation files included in a header)
#
# LIBS : optional
#   list of libraries to link against (CMake targets or external libraries)
#
# NO_AS_NEEDED: optional
#   add --no-as-needed linker flag, to prevent stripping libraries that looks like are not used
#
# INCLUDES : optional
#   list of paths to add to include directories
#
# DEFINITIONS : optional
#   list of definitions to add to preprocessor defines
#
# PERSISTENT : optional
#   list of persistent layer object files
#
# GENERATED : optional
#   list of files to mark as generated (sets GENERATED source file property)
#
# DEPENDS : optional
#   list of targets to be built before this target
#
# CONDITION : optional
#   conditional expression which must evaluate to true for this target to be
#   built (must be valid in a CMake ``if`` statement)
#
# PROPERTIES : optional
#   custom properties to set on the target
#
# NOINSTALL : optional
#   do not install the executable
#
# VERSION : optional, AUTO_VERSION or LIBS_VERSION is used if not specified
#   version to use as executable version
#
# AUTO_VERSION : optional, ignored if VERSION is specified
#   automatically version the executable with the package version
#
# CFLAGS : optional
#   list of C compiler flags to use for all C source files
#
#   See usage note below.
#
# CXXFLAGS : optional
#   list of C++ compiler flags to use for all C++ source files
#
#   See usage note below.
#
# FFLAGS : optional
#   list of Fortran compiler flags to use for all Fortran source files
#
#   See usage note below.
#
# LINKER_LANGUAGE : optional
#   sets the LINKER_LANGUAGE property on the target
#
# OUTPUT_NAME : optional
#   sets the OUTPUT_NAME property on the target
#
# Usage
# -----
#
# The ``CFLAGS``, ``CXXFLAGS`` and ``FFLAGS`` options apply the given compiler
# flags to all C, C++ and Fortran sources passed to this command, respectively.
# If any two ``ecbuild_add_executable``, ``ecbuild_add_library`` or
# ``ecbuild_add_test`` commands are passed the *same* source file and each sets
# a different value for the compiler flags to be applied to that file (including
# when one command adds flags and another adds none), then the two commands
# will be in conflict and the result may not be as expected.
#
# For this reason it is recommended not to use the ``*FLAGS`` options when
# multiple targets share the same source files, unless the exact same flags are
# applied to those sources by each relevant command.
#
# Care should also be taken to ensure that these commands are not passed source
# files which are not required to build the target, if those sources are also
# passed to other commands which set different compiler flags.
#
##############################################################################

function( ecbuild_add_executable )

  set( options NOINSTALL AUTO_VERSION NO_AS_NEEDED )
  set( single_value_args TARGET COMPONENT LINKER_LANGUAGE VERSION OUTPUT_NAME )
  set( multi_value_args SOURCES SOURCES_GLOB SOURCES_EXCLUDE_REGEX OBJECTS
                        TEMPLATES LIBS INCLUDES DEPENDS PERSISTENT DEFINITIONS
                        CFLAGS CXXFLAGS FFLAGS GENERATED CONDITION PROPERTIES )

  cmake_parse_arguments( _PAR "${options}" "${single_value_args}" "${multi_value_args}"  ${_FIRST_ARG} ${ARGN} )

  if(_PAR_UNPARSED_ARGUMENTS)
    ecbuild_critical("Unknown keywords given to ecbuild_add_executable(): \"${_PAR_UNPARSED_ARGUMENTS}\"")
  endif()

  if( NOT _PAR_TARGET  )
    ecbuild_critical("The call to ecbuild_add_executable() doesn't specify the TARGET.")
  endif()

  if( NOT _PAR_SOURCES AND NOT _PAR_OBJECTS AND NOT _PAR_SOURCES_GLOB )
    ecbuild_critical("The call to ecbuild_add_executable() specifies neither SOURCES nor OBJECTS nor SOURCES_GLOB.")
  endif()

  ### conditional build
  ecbuild_evaluate_dynamic_condition( _PAR_CONDITION _${_PAR_TARGET}_condition )

  if( _${_PAR_TARGET}_condition )

    # insert already compiled objects (from OBJECT libraries)
    unset( _all_objects )
    foreach( _obj ${_PAR_OBJECTS} )
      list( APPEND _all_objects $<TARGET_OBJECTS:${_obj}> )
    endforeach()

    # glob sources
    unset( _glob_srcs )
    foreach( pattern ${_PAR_SOURCES_GLOB} )
      ecbuild_list_add_pattern( LIST _glob_srcs GLOB "${pattern}" )
    endforeach()

    foreach( pattern ${_PAR_SOURCES_EXCLUDE_REGEX} )
      ecbuild_list_exclude_pattern( LIST _glob_srcs REGEX "${pattern}" )
    endforeach()

    list( APPEND _PAR_SOURCES ${_glob_srcs} )

    if( ECBUILD_LIST_SOURCES )
      ecbuild_debug("ecbuild_add_library(${_PAR_TARGET}): sources ${_PAR_SOURCES}")
    endif()

    # add persistent layer files
    ecbuild_add_persistent( SRC_LIST _PAR_SOURCES FILES ${_PAR_PERSISTENT} NAMESPACE "${PERSISTENT_NAMESPACE}" )

    # remove templates from compilation sources
    if( DEFINED _PAR_TEMPLATES )
      ecbuild_debug("ecbuild_add_executable(${_PAR_TARGET}): removing ${_PAR_TEMPLATES} from sources")
      list( REMOVE_ITEM _PAR_SOURCES ${_PAR_TEMPLATES} )
      add_custom_target( ${_PAR_TARGET}_templates SOURCES ${_PAR_TEMPLATES} )
    endif()

    # Separate sources
    if( _PAR_SOURCES )
      ecbuild_separate_sources( TARGET ${_PAR_TARGET} SOURCES ${_PAR_SOURCES} )
    endif()

    if( ${_PAR_TARGET}_cuda_srcs AND CUDA_FOUND )
      cuda_add_executable( ${_PAR_TARGET} ${_PAR_SOURCES}  ${_all_objects} )
    else()
      add_executable( ${_PAR_TARGET} ${_PAR_SOURCES} ${_all_objects} )
    endif()

    # Set custom properties
    if( ${_PAR_PROPERTIES} )
      set_target_properties( ${_PAR_TARGET} PROPERTIES ${_PAR_PROPERTIES} )
    endif()

    # ecbuild_echo_target( ${_PAR_TARGET} )

    # add include dirs if defined
    if( DEFINED _PAR_INCLUDES )
      ecbuild_filter_list(INCLUDES LIST ${_PAR_INCLUDES} LIST_INCLUDE path LIST_EXCLUDE skipped_path)
      ecbuild_debug("ecbuild_add_executable(${_PAR_TARGET}): add [${path}] to include_directories")
      target_include_directories( ${_PAR_TARGET} PRIVATE ${path} )
      ecbuild_debug("ecbuild_add_executable(${_PAR_TARGET}): [${skipped_path}] not found - not adding to include_directories")
    endif()

    # set OUTPUT_NAME

    if( DEFINED _PAR_OUTPUT_NAME )
      ecbuild_debug("ecbuild_add_executable(${_PAR_TARGET}): set OUTPUT_NAME to ${_PAR_OUTPUT_NAME}")
      set_target_properties( ${_PAR_TARGET} PROPERTIES OUTPUT_NAME ${_PAR_OUTPUT_NAME} )
    endif()

    # add extra dependencies
    if( DEFINED _PAR_DEPENDS)
      ecbuild_debug("ecbuild_add_executable(${_PAR_TARGET}): add dependency on ${_PAR_DEPENDS}")
      add_dependencies( ${_PAR_TARGET} ${_PAR_DEPENDS} )
    endif()

    # add the link libraries
    if( DEFINED _PAR_LIBS )
      list(REMOVE_ITEM _PAR_LIBS debug)
      list(REMOVE_ITEM _PAR_LIBS optimized)
      ecbuild_filter_list(LIBS LIST ${_PAR_LIBS} LIST_INCLUDE lib LIST_EXCLUDE skipped_lib)
      if ( _PAR_NO_AS_NEEDED AND CMAKE_SYSTEM_NAME MATCHES "Linux" AND CMAKE_CXX_COMPILER_ID MATCHES "GNU" )
        target_link_libraries( ${_PAR_TARGET} -Wl,--no-as-needed ${lib} )
      else()
        target_link_libraries( ${_PAR_TARGET} ${lib} )
      endif()
      ecbuild_debug("ecbuild_add_executable(${_PAR_TARGET}): linking with [${lib}]")
      ecbuild_debug("ecbuild_add_executable(${_PAR_TARGET}): [${skipped_lib}] not found - not linking")
    endif()

    # Override compilation flags on a per source file basis
    ecbuild_target_flags( ${_PAR_TARGET} "${_PAR_CFLAGS}" "${_PAR_CXXFLAGS}" "${_PAR_FFLAGS}" )

    # define VERSION if requested
    if( DEFINED _PAR_VERSION )
      ecbuild_debug("ecbuild_add_executable(${_PAR_TARGET}): set version to ${_PAR_VERSION}")
      set_target_properties( ${_PAR_TARGET} PROPERTIES VERSION "${_PAR_VERSION}" )
    else()
      if( _PAR_AUTO_VERSION )
        ecbuild_debug("ecbuild_add_executable(${_PAR_TARGET}): set version to ${${PROJECT_NAME}_VERSION_MAJOR}.${${PROJECT_NAME}_VERSION_MINOR}")
        set_target_properties( ${_PAR_TARGET} PROPERTIES VERSION "${${PROJECT_NAME}_VERSION_MAJOR}.${${PROJECT_NAME}_VERSION_MINOR}" )
      endif()
    endif()

    # installation

    if( NOT _PAR_NOINSTALL )
      ecbuild_debug("ecbuild_add_executable(${_PAR_TARGET}): installing to ${INSTALL_BIN_DIR}")

      # add installation paths and associate with defined component
      #            if( DEFINED _PAR_COMPONENT )
      #                set( COMPONENT_DIRECTIVE "${_PAR_COMPONENT}" )
      #            else()
      #                set( COMPONENT_DIRECTIVE "${PROJECT_NAME}" )
      #            endif()

      install( TARGETS ${_PAR_TARGET}
               EXPORT  ${PROJECT_NAME}-targets
               RUNTIME DESTINATION ${INSTALL_BIN_DIR}
               LIBRARY DESTINATION ${INSTALL_LIB_DIR}
               ARCHIVE DESTINATION ${INSTALL_LIB_DIR} )
      #        COMPONENT ${COMPONENT_DIRECTIVE} )

      # set build location

      set_target_properties( ${_PAR_TARGET} PROPERTIES RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin )

      # export location of target to other projects -- must be exactly after setting the build location (see previous command)

      export( TARGETS ${_PAR_TARGET} APPEND FILE "${PROJECT_TARGETS_FILE}" )

    else()
      ecbuild_debug("ecbuild_add_executable(${_PAR_TARGET}): not installing")
      # NOINSTALL targets are always built the build_rpath, not the install_rpath
      set_target_properties( ${_PAR_TARGET} PROPERTIES SKIP_BUILD_RPATH         FALSE )
      set_target_properties( ${_PAR_TARGET} PROPERTIES BUILD_WITH_INSTALL_RPATH FALSE )
    endif()

    # add definitions to compilation
    if( DEFINED _PAR_DEFINITIONS )
      target_compile_definitions(${_PAR_TARGET} PRIVATE ${_PAR_DEFINITIONS})
      ecbuild_debug("ecbuild_add_executable(${_PAR_TARGET}): adding definitions ${_PAR_DEFINITIONS}")
    endif()

    # set linker language
    if( DEFINED _PAR_LINKER_LANGUAGE )
      ecbuild_debug("ecbuild_add_executable(${_PAR_TARGET}): using linker language ${_PAR_LINKER_LANGUAGE}")
      set_target_properties( ${_PAR_TARGET} PROPERTIES LINKER_LANGUAGE ${_PAR_LINKER_LANGUAGE} )
      if( ECBUILD_${_PAR_LINKER_LANGUAGE}_IMPLICIT_LINK_LIBRARIES )
        target_link_libraries( ${_PAR_TARGET} ${ECBUILD_${_PAR_LINKER_LANGUAGE}_IMPLICIT_LINK_LIBRARIES} )
      endif()
    endif()

    if( ECBUILD_IMPLICIT_LINK_LIBRARIES )
      target_link_libraries( ${_PAR_TARGET} ${ECBUILD_IMPLICIT_LINK_LIBRARIES} )
    endif()

    # make sure target is removed before - some problems with AIX
    add_custom_command( TARGET ${_PAR_TARGET} PRE_BUILD COMMAND ${CMAKE_COMMAND} -E remove $<TARGET_FILE:${_PAR_TARGET}> )

    # append to the list of this project targets
    set( ${PROJECT_NAME}_ALL_EXES ${${PROJECT_NAME}_ALL_EXES} ${_PAR_TARGET} CACHE INTERNAL "" )

  endif()

  # mark source files as used
  ecbuild_declare_project_files( ${_PAR_SOURCES} )
  if( DEFINED _PAR_TEMPLATES )
    ecbuild_declare_project_files( ${_PAR_TEMPLATES} )
  endif()

endfunction( ecbuild_add_executable  )
