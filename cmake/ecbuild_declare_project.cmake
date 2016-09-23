# (C) Copyright 1996-2016 ECMWF.
#
# This software is licensed under the terms of the Apache Licence Version 2.0
# which can be obtained at http://www.apache.org/licenses/LICENSE-2.0.
# In applying this licence, ECMWF does not waive the privileges and immunities
# granted to it by virtue of its status as an intergovernmental organisation nor
# does it submit to any jurisdiction.

##############################################################################
#.rst:
#
# ecbuild_declare_project
# =======================
#
# Initialise an ecBuild project. A CMake project must have previously been
# declared with ``project( <name> ... )``. ::
#
#   ecbuild_declare_project()
#
# Sets the following CMake variables
# (where ``PNAME`` is the capitalised project name):
#
# :<PNAME>_GIT_SHA1:       Git revision (if project is a Git repo)
# :<PNAME>_GIT_SHA1_SHORT: short Git revision (if project is a Git repo)
# :<PNAME>_VERSION:        version in format ``MAJOR.MINOR.PATCH``
# :<PNAME>_VERSION_STR:    version as given in ``VERSION.cmake`` or 0.0.0
# :<PNAME>_MAJOR_VERSION:  major version number
# :<PNAME>_MINOR_VERSION:  minor version number
# :<PNAME>_PATCH_VERSION:  patch version number
# :INSTALL_BIN_DIR:        relative install directory for executables
# :INSTALL_LIB_DIR:        relative install directory for libraries
# :INSTALL_INCLUDE_DIR:    relative install directory for include files
# :INSTALL_DATA_DIR:       relative install directory for data
# :INSTALL_CMAKE_DIR:      relative install directory for CMake files
#
# The relative installation directories of components can be customised by
# setting the following CMake variables on the command line or in cache:
#
# :INSTALL_BIN_DIR:        directory for installing executables
#                          (default: ``bin``)
# :INSTALL_LIB_DIR:        directory for installing libraries
#                          (default: ``lib``)
# :INSTALL_INCLUDE_DIR:    directory for installing include files
#                          (default: ``include``)
# :INSTALL_DATA_DIR:       directory for installing data
#                          (default: ``share/<project_name>``)
# :INSTALL_CMAKE_DIR:      directory for installing CMake files
#                          (default: ``share/<project_name>/cmake``)
#
# Using *relative* paths is recommended, which are interpreted relative to the
# ``CMAKE_INSTALL_PREFIX``. Using absolute paths makes the build
# non-relocatable and may break the generation of relocatable binary packages.
#
# Compiler flags can be overridden on a per source file basis by providing a
# JSON file defining the override rules and setting ``ECBUILD_SOURCE_FLAGS``
# to the *full path* of this file. If set, ``<PNAME>_ECBUILD_SOURCE_FLAGS``
# takes precendence and ``ECBUILD_SOURCE_FLAGS`` is ignored.
#
# The JSON file lists shell glob patterns and the rule to apply to each source
# file matching the pattern, defined as an array ``[op, flag1, ...]``
# containing an operator followed by one or more flags. Valid operators are:
#
# :+: Add the flags to the default compilation flags for matching files
# :=: Set the flags for matching files, disregarding default compilation flags
# :/: Remove the flags from the default compilation flags for matching files
#
# Rules can be nested to e.g. only apply to a subdirectory by setting the rule
# to a dictionary, which will only apply to source files matching it pattern.
#
# An example JSON file demonstrating different rule types is given below: ::
#
#   {
#     "*"       : [ "+", "-g0" ],
#     "*.cxx"   : [ "+", "-cxx11" ],
#     "*.f90"   : [ "+", "-pipe" ],
#     "foo.c"   : [ "+", "-O0" ],
#     "foo.cc"  : [ "+", "-O2", "-pipe" ],
#     "bar/*": {
#       "*.f90" : [ "=", "-O1" ]
#     },
#     "baz/*": {
#       "*.f90" : [ "/", "-pipe" ],
#       "*.f90" : [ "/", "-O2" ],
#       "*.f90" : [ "+", "-O3" ]
#     }
#   }
#
##############################################################################

macro( ecbuild_declare_project )

  string( TOUPPER ${PROJECT_NAME} PNAME )

  # reset the lists of targets (executables, libs, tests & resources)

  set( ${PROJECT_NAME}_ALL_EXES "" CACHE INTERNAL "" )
  set( ${PROJECT_NAME}_ALL_LIBS "" CACHE INTERNAL "" )

  # if git project get its HEAD SHA1
  # leave it here so we may use ${PNAME}_GIT_SHA1 on the version file

  if( EXISTS ${PROJECT_SOURCE_DIR}/.git )
    get_git_head_revision( GIT_REFSPEC ${PNAME}_GIT_SHA1 )
    if( ${PNAME}_GIT_SHA1 )
      string( SUBSTRING "${${PNAME}_GIT_SHA1}" 0 7 ${PNAME}_GIT_SHA1_SHORT )
      #     ecbuild_debug_var( ${PNAME}_GIT_SHA1 )
      #     ecbuild_debug_var( ${PNAME}_GIT_SHA1_SHORT )
    else()
      ecbuild_debug( "Could not get git-sha1 for project ${PNAME}")
    endif()
  endif()

  # read and parse project version file
  if( EXISTS ${PROJECT_SOURCE_DIR}/VERSION.cmake )
    include( ${PROJECT_SOURCE_DIR}/VERSION.cmake )
  else()
    set( ${PROJECT_NAME}_VERSION_STR "0.0.0" )
  endif()

  string( REPLACE "." " " _version_list ${${PROJECT_NAME}_VERSION_STR} ) # dots to spaces

  separate_arguments( _version_list )

  list( GET _version_list 0 ${PNAME}_MAJOR_VERSION )
  list( GET _version_list 1 ${PNAME}_MINOR_VERSION )
  list( GET _version_list 2 ${PNAME}_PATCH_VERSION )

  # cleanup patch version of any extra qualifiers ( -dev -rc1 ... )

  string( REGEX REPLACE "^([0-9]+).*" "\\1" ${PNAME}_PATCH_VERSION "${${PNAME}_PATCH_VERSION}" )

  set( ${PNAME}_VERSION "${${PNAME}_MAJOR_VERSION}.${${PNAME}_MINOR_VERSION}.${${PNAME}_PATCH_VERSION}"
       CACHE INTERNAL "package ${PNAME} version" )

  set( ${PNAME}_VERSION_STR "${${PROJECT_NAME}_VERSION_STR}"
       CACHE INTERNAL "package ${PNAME} version string" ) # ignore caps

  #    ecbuild_debug_var( ${PNAME}_VERSION )
  #    ecbuild_debug_var( ${PNAME}_VERSION_STR )
  #    ecbuild_debug_var( ${PNAME}_MAJOR_VERSION )
  #    ecbuild_debug_var( ${PNAME}_MINOR_VERSION )
  #    ecbuild_debug_var( ${PNAME}_PATCH_VERSION )

  # Override source flags with project specific flags
  foreach( _flags COMPILE SOURCE )
    if( ${PNAME}_ECBUILD_${_flags}_FLAGS )
      if ( ECBUILD_${_flags}_FLAGS )
        ecbuild_debug( "Override ECBUILD_${_flags}_FLAGS (${ECBUILD_${_flags}_FLAGS}) with ${PROJECT_NAME} specific flags (${${PNAME}_ECBUILD_${_flags}_FLAGS})" )
      else()
        ecbuild_debug( "Use ${PROJECT_NAME} specific ECBUILD_${_flags}_FLAGS (${${PNAME}_ECBUILD_${_flags}_FLAGS})" )
      endif()
      set( ECBUILD_${_flags}_FLAGS ${${PNAME}_ECBUILD_${_flags}_FLAGS} )
    endif()
    # Ensure ECBUILD_${_flags}_FLAGS is a valid file path
    if( DEFINED ECBUILD_${_flags}_FLAGS AND NOT EXISTS ${ECBUILD_${_flags}_FLAGS} )
      ecbuild_warn( "ECBUILD_${_flags}_FLAGS points to non-existent file ${ECBUILD_${_flags}_FLAGS} and will be ignored" )
      unset( ECBUILD_${_flags}_FLAGS )
      unset( ECBUILD_${_flags}_FLAGS CACHE )
    endif()
  endforeach()
  if( ECBUILD_COMPILE_FLAGS )
    include( "${ECBUILD_COMPILE_FLAGS}" )
  endif()

  # install dirs for this project

  # Use defaults unless values are already present in cache
  if( NOT INSTALL_BIN_DIR )
    set( INSTALL_BIN_DIR bin )
  endif()
  if( NOT INSTALL_LIB_DIR )
    set( INSTALL_LIB_DIR lib )
  endif()
  if( NOT INSTALL_INCLUDE_DIR )
    set( INSTALL_INCLUDE_DIR include )
  endif()
  if( NOT INSTALL_DATA_DIR )
    set( INSTALL_DATA_DIR share/${PROJECT_NAME} )
  endif()
  if( NOT INSTALL_CMAKE_DIR )
    set( INSTALL_CMAKE_DIR share/${PROJECT_NAME}/cmake )
  endif()

  mark_as_advanced( INSTALL_BIN_DIR )
  mark_as_advanced( INSTALL_LIB_DIR )
  mark_as_advanced( INSTALL_INCLUDE_DIR )
  mark_as_advanced( INSTALL_DATA_DIR )
  mark_as_advanced( INSTALL_CMAKE_DIR )

  # overrides of install dirs (deprecated in ecBuild 2.4.0)

  foreach( p LIB BIN INCLUDE DATA CMAKE )
    if( ${PNAME}_INSTALL_${p}_DIR )
      ecbuild_deprecate( "Use of ${PNAME}_INSTALL_${p}_DIR is deprecated and will be removed in a future release. Use INSTALL_${p}_DIR instead." )
      set( INSTALL_${p}_DIR ${${PNAME}_INSTALL_${p}_DIR} )
    endif()
  endforeach()

  # warnings for non-relocatable projects

  foreach( p LIB BIN INCLUDE DATA CMAKE )
    if( IS_ABSOLUTE ${INSTALL_${p}_DIR} )
      ecbuild_warn( "Defining INSTALL_${p}_DIR as absolute path '${INSTALL_${p}_DIR}' makes this build non-relocatable, possibly breaking the installation of RPMS and DEB packages" )
    endif()
  endforeach()

  # make relative paths absolute ( needed later on ) and cache them ...
  foreach( p LIB BIN INCLUDE DATA CMAKE )

    set( var INSTALL_${p}_DIR )

    if( NOT IS_ABSOLUTE "${${var}}" )
      set( ${PNAME}_FULL_INSTALL_${p}_DIR "${CMAKE_INSTALL_PREFIX}/${${var}}"
           CACHE INTERNAL "${PNAME} ${p} full install path" )
    else()
      ecbuild_warn( "Setting an absolute path for ${VAR} in project ${PNAME}, breakes generation of relocatable binary packages (rpm,deb,...)" )
      set( ${PNAME}_FULL_INSTALL_${p}_DIR "${${var}}"
           CACHE INTERNAL "${PNAME} ${p} full install path" )
    endif()

    #        ecbuild_debug_var( ${PNAME}_FULL_INSTALL_${p}_DIR )

  endforeach()

  # correctly set CMAKE_INSTALL_RPATH

  if( ENABLE_RPATHS )

    if( ENABLE_RELATIVE_RPATHS )

      file( RELATIVE_PATH relative_rpath ${${PNAME}_FULL_INSTALL_BIN_DIR} ${${PNAME}_FULL_INSTALL_LIB_DIR} )
      # ecbuild_debug_var( relative_rpath )

      ecbuild_append_to_rpath( ${relative_rpath} )

    else() # make rpaths absolute

      if( IS_ABSOLUTE ${INSTALL_LIB_DIR} )
        ecbuild_append_to_rpath( "${INSTALL_LIB_DIR}" )
      else()
        ecbuild_append_to_rpath( "${CMAKE_INSTALL_PREFIX}/${INSTALL_LIB_DIR}" )
      endif()

    endif()

  endif()

  # ecbuild_debug_var( CMAKE_INSTALL_RPATH )

  # print project header

  message( STATUS "---------------------------------------------------------" )

  if( ${PNAME}_GIT_SHA1_SHORT )
    ecbuild_info( "[${PROJECT_NAME}] (${${PNAME}_VERSION_STR}) [${${PNAME}_GIT_SHA1_SHORT}]" )
  else()
    ecbuild_info( "[${PROJECT_NAME}] (${${PNAME}_VERSION_STR})" )
  endif()

endmacro( ecbuild_declare_project )
