# (C) Copyright 2011- ECMWF.
#
# This software is licensed under the terms of the Apache Licence Version 2.0
# which can be obtained at http://www.apache.org/licenses/LICENSE-2.0.
# In applying this licence, ECMWF does not waive the privileges and immunities
# granted to it by virtue of its status as an intergovernmental organisation nor
# does it submit to any jurisdiction.

##############################################################################

# Write transitive list of library dependencies of each library in ${libraries}
# to CMake variable ${dependencies}
function( _ecbuild_library_dependencies_impl dependencies libraries )

  set( _dependencies "" )
  set( _libraries ${${libraries}} )

  foreach( _lib ${_libraries})

    unset( _location )

    string( REGEX REPLACE "^\\$<LINK_ONLY:" "" _lib ${_lib} )
    string( REGEX REPLACE ">$" "" _lib ${_lib} )

    if( TARGET ${_lib} ) # check if this is an existing target

      get_property( _type TARGET ${_lib} PROPERTY TYPE )
      if( NOT( "${_type}" STREQUAL "INTERFACE_LIBRARY" ) )
        list( APPEND _location ${_lib} )

        unset( _deps )
        get_property( _deps TARGET ${_lib} PROPERTY LINK_LIBRARIES )
        if( _deps )
          _ecbuild_library_dependencies_impl( _deps_location _deps )
          list( APPEND _location ${_deps_location} )
        endif()
      endif()

      unset( _deps )
      get_property( _deps TARGET ${_lib} PROPERTY INTERFACE_LINK_LIBRARIES )
      if( _deps )
        _ecbuild_library_dependencies_impl( _deps_location _deps )
        list( APPEND _location ${_deps_location} )
      endif()

    else()

      set( _location ${_lib} )

    endif()

    list( APPEND _dependencies ${_location} )

  endforeach()

  if( _dependencies )
    list( REVERSE           _dependencies )
    list( REMOVE_DUPLICATES _dependencies )
    list( REVERSE           _dependencies )
    set( ${dependencies} ${_dependencies} PARENT_SCOPE )
  endif()

endfunction()


function(ecbuild_library_dependencies dependencies libraries)
  _ecbuild_library_dependencies_impl(_dependencies ${libraries} )
  foreach( _lib ${${libraries}} )
    list( REMOVE_ITEM _dependencies ${_lib} )
  endforeach()
  if( _dependencies )
    set( ${dependencies} ${_dependencies} PARENT_SCOPE )
  endif()
endfunction()

##############################################################################

# Write list of include directories of each library in ${libraries}
# to CMake variable ${dependencies}
function( ecbuild_include_dependencies dependencies libraries )

  set( _dependencies "" )
  set( _libraries ${${libraries}} )

  foreach( _lib ${_libraries})

    if( TARGET ${_lib} ) # check if this is an existing target

      get_property( _include_dirs TARGET ${_lib} PROPERTY INTERFACE_INCLUDE_DIRECTORIES )

      # drop build interface
      string(REGEX REPLACE "\\$<BUILD_INTERFACE:([^>]+)>;?" "" _include_dirs "${_include_dirs}")
      # resolve install interface
      string(REGEX REPLACE "\\$<INSTALL_INTERFACE:([^>]+)>" "\\1" _include_dirs "${_include_dirs}")

      # resolve relative includes
      foreach(_include ${_include_dirs})
        if(IS_ABSOLUTE ${_include})
          list(APPEND _dependencies "${_include}")
        else()
          list(APPEND _dependencies "${CMAKE_INSTALL_PREFIX}/${_include}")
        endif()
      endforeach()

    endif()

  endforeach()

  if( _dependencies )
    list( REMOVE_DUPLICATES _dependencies )
    set( ${dependencies} ${_dependencies} PARENT_SCOPE )
  endif()

endfunction(ecbuild_include_dependencies)

##############################################################################

# Transform list of libraries in ${libraries}, ignoring any in ${ignore_libs},
# and write pkg-config compatible string to CMake variable ${pkgconfig_libs}
function( ecbuild_pkgconfig_libs pkgconfig_libs libraries ignore_libs )

  set( _libraries ${${libraries}} )
  set( _ignore_libs ${${ignore_libs}} )
  set( _pkgconfig_libs "" )

  if( CMAKE_CXX_COMPILER_LOADED )
   set( _linker_lang CXX )
  elseif( CMAKE_C_COMPILER_LOADED )
   set( _linker_lang C )
  elseif( CMAKE_Fortran_COMPILER_LOADED )
   set( _linker_lang Fortran )
  endif()

  set( RPATH_FLAG ${CMAKE_SHARED_LIBRARY_RUNTIME_${_linker_lang}_FLAG} )

  foreach( _lib ${_libraries} )

    set( _skip FALSE )
    if( TARGET ${_lib} )
      get_property( _type TARGET ${_lib} PROPERTY TYPE )
      if( "${_type}" STREQUAL "INTERFACE_LIBRARY" )
        set( _skip TRUE )
      endif()
    endif()

    if( NOT _skip )
        unset( _name )
        unset( _dir  )

        if( ${_lib} MATCHES ".+/Frameworks/.+" )

          get_filename_component( _name ${_lib} NAME_WE )
          list( APPEND _pkgconfig_libs "-framework ${_name}" )

        else()

          if( TARGET ${_lib} )

            # XXX: %SHORTEN:...% will be resolved later, see pkg-config.cmake.in
            set( _name "%SHORTEN:$<TARGET_LINKER_FILE_NAME:${_lib}>%" )
            set( _dir "$<TARGET_LINKER_FILE_DIR:${_lib}>" )

          elseif( ${_lib} MATCHES "-l.+" )

            string( REGEX REPLACE "^-l" "" _name ${_lib} )

          else()

            get_filename_component( _name ${_lib} NAME_WE )
            get_filename_component( _dir  ${_lib} PATH )

            if( NOT _name )
              set( _name ${_lib} )
            endif()

            string( REGEX REPLACE "^lib" "" _name ${_name} )

            if( "${_dir}" STREQUAL "/usr/lib" )
              unset( _dir )
            endif()
            if( "${_dir}" STREQUAL "/usr/lib64" )
              unset( _dir )
            endif()

          endif()

          set( _set_append TRUE )
            foreach( _ignore ${_ignore_libs} )
              if( "${_name}" STREQUAL "${_ignore}" )
                set( _set_append FALSE )
              endif()
          endforeach()

          if( _set_append )

            if( _dir )
              list( APPEND _pkgconfig_libs "${RPATH_FLAG}${_dir}" "-L${_dir}" "-l${_name}" )
            else()
              list( APPEND _pkgconfig_libs "-l${_name}" )
            endif()

          endif()

        endif( ${_lib} MATCHES ".+/Frameworks/.+" )
    endif()

  endforeach( _lib ${_libraries} )

  if( _pkgconfig_libs )
    list( REMOVE_DUPLICATES _pkgconfig_libs )
    string( REPLACE ";" " " _pkgconfig_libs "${_pkgconfig_libs}" )
    set( ${pkgconfig_libs} ${_pkgconfig_libs} PARENT_SCOPE )
  endif()

endfunction(ecbuild_pkgconfig_libs)

##############################################################################

# Transform list of include directories in ${INCLUDE_DIRS}, ignoring any in
# ${ignore_includes} and ${${PNAME}_INCLUDE_DIRS}, and write pkg-config
# compatible string to CMake variable ${INCLUDE}
function( ecbuild_pkgconfig_include INCLUDE INCLUDE_DIRS ignore_includes )

  string( TOUPPER ${PROJECT_NAME} PNAME )

  set( _ignore_includes ${${ignore_includes}} )

  list( APPEND ignore_include_dirs
    "/usr/include"
     ${${PNAME}_INCLUDE_DIRS} # These are build-directory includes
     ${CMAKE_SOURCE_DIR}      # Ignore private includes referencing source tree
     ${CMAKE_BINARY_DIR}      # Ignore private includes referencing build tree
     "\\$<BUILD_INTERFACE"    # Ignore generator expressions
     "\\$<INSTALL_INTERFACE"  # Ignore generator expressions
     ${_ignore_includes}
  )
  set( ignore_include_dirs_escaped )
  foreach( _ignore ${ignore_include_dirs} )
    ecbuild_regex_escape( "${_ignore}" _ignore_escaped )
    list( APPEND ignore_include_dirs_escaped "${_ignore_escaped}" )
  endforeach()

  foreach( _incdir ${${INCLUDE_DIRS}} )

    foreach( _ignore ${ignore_include_dirs_escaped} )
      if( "${_incdir}" MATCHES "${_ignore}" )
        unset( _incdir )
        break()
      endif()
    endforeach()

    if( _incdir )
      list( APPEND _include "-I${_incdir}")
    endif()

  endforeach()

  if( _include )
    list( REMOVE_DUPLICATES _include)
    string( REPLACE ";" " " _include "${_include}")
    set( ${INCLUDE} ${_include} PARENT_SCOPE )
  endif()

endfunction(ecbuild_pkgconfig_include)

##############################################################################
#.rst:
#
# ecbuild_pkgconfig
# =================
#
# Create a pkg-config file for the current project. ::
#
#   ecbuild_pkgconfig( [ NAME <name> ]
#                      [ FILENAME <filename> ]
#                      [ TEMPLATE <template> ]
#                      [ URL <url> ]
#                      [ DESCRIPTION <description> ]
#                      [ LIBRARIES <lib1> [ <lib2> ... ] ]
#                      [ IGNORE_INCLUDE_DIRS <dir1> [ <dir2> ... ] ]
#                      [ IGNORE_LIBRARIES <lib1> [ <lib2> ... ] ]
#                      [ LANGUAGES <language1> [ <language2> ... ] ]
#                      [ VARIABLES <variable1> [ <variable2> ... ] ]
#                      [ NO_PRIVATE_INCLUDE_DIRS ] )
#
# Options
# -------
#
# NAME : optional, defaults to lower case name of the project
#   name to be given to the package
#
# FILENAME : optional, defaults to ``<NAME>.pc``
#   file to be generated, including .pc extension
#
# TEMPLATE : optional, defaults to ``${ECBUILD_CMAKE_DIR}/pkg-config.pc.in``
#   template configuration file to use
#
#   This is useful to create customised pkg-config files.
#
# URL : optional, defaults to ``${PROJECT_NAME}_URL``
#   url of the package
#
# DESCRIPTION : optional, defaults to ``${PROJECT_NAME}_DESCRIPTION``
#   description of the package
#
# LIBRARIES : required
#   list of package libraries
#
# IGNORE_INCLUDE_DIRS : optional
#   list of include directories to ignore
#
# IGNORE_LIBRARIES : optional
#   list of libraries to ignore i.e. those are removed from ``LIBRARIES``
#
# VARIABLES : optional
#   list of additional CMake variables to export to the pkg-config file
#
# LANGUAGES : optional, defaults to all loaded languages
#   list of languages to use. Accepted languages: C CXX Fortran
#
# NO_PRIVATE_INCLUDE_DIRS
#   do not add include directories of dependencies to Cflags
#
#   This is mainly useful for Fortran only packages, when only modules need
#   to be added to Cflags.
#
# Input variables
# ---------------
#
# The following CMake variables are used as default values for some of the
# options listed above:
#
# :<PROJECT_NAME>_DESCRIPTION:  package description
# :<PROJECT_NAME>_URL:          package URL
# :<PROJECT_NAME>_VERSION:      package version
# :<PROJECT_NAME>_GIT_SHA1:     Git revision
#
# Usage
# -----
#
# It is good practice to provide a separate pkg-config file for each library a
# package exports. This can be achieved as follows::
#
#   foreach( _lib ${${PNAME}_LIBRARIES} )
#     if( TARGET ${_lib} )
#       ecbuild_pkgconfig( NAME ${_lib}
#                          DESCRIPTION "..."
#                          URL "..."
#                          LIBRARIES ${_lib} )
#     endif()
#   endforeach()
#
##############################################################################

function( ecbuild_pkgconfig )
if(HAVE_PKGCONFIG)
  set( options REQUIRES NO_PRIVATE_INCLUDE_DIRS )
  set( single_value_args FILENAME NAME TEMPLATE URL DESCRIPTION )
  set( multi_value_args LIBRARIES IGNORE_INCLUDE_DIRS IGNORE_LIBRARIES VARIABLES LANGUAGES )

  cmake_parse_arguments( _PAR "${options}" "${single_value_args}" "${multi_value_args}"  ${_FIRST_ARG} ${ARGN} )

  string( TOUPPER ${PROJECT_NAME} PNAME )
  string( TOLOWER ${PROJECT_NAME} LNAME )

  if(_PAR_UNPARSED_ARGUMENTS)
    ecbuild_critical("Unknown keywords given to ecbuild_add_executable(): \"${_PAR_UNPARSED_ARGUMENTS}\"")
  endif()

  if( NOT _PAR_LIBRARIES)
    if(ECBUILD_2_COMPAT)
      if(ECBUILD_2_COMPAT_DEPRECATE)
        ecbuild_deprecate("Please specify the LIBRARIES argument of ecbuild_pkgconfig.")
      endif()
      set( LIBRARIES ${${PNAME}_LIBRARIES} )
    else()
      ecbuild_critical("The call to ecbuild_pkgconfig() doesn't specify the LIBRARIES.")
    endif()
  endif()

  unset( PKGCONFIG_LANGUAGES )
  if( NOT _PAR_LANGUAGES )
    if( CMAKE_C_COMPILER_LOADED )
      list( APPEND PKGCONFIG_LANGUAGES C )
    endif()
    if( CMAKE_CXX_COMPILER_LOADED )
      list( APPEND PKGCONFIG_LANGUAGES CXX )
    endif()
    if( CMAKE_Fortran_COMPILER_LOADED )
      list( APPEND PKGCONFIG_LANGUAGES Fortran )
    endif()
  else()
    foreach( _lang ${_PAR_LANGUAGES} )
      if( CMAKE_${_lang}_COMPILER_LOADED )
        list( APPEND PKGCONFIG_LANGUAGES ${_lang} )
      endif()
    endforeach()
  endif()

  foreach( _lang ${PKGCONFIG_LANGUAGES} )
    set( PKGCONFIG_HAVE_${_lang} 1 )
  endforeach()

  if( _PAR_LIBRARIES )
    set( LIBRARIES ${_PAR_LIBRARIES} )
  endif()

  if( CMAKE_CXX_COMPILER_LOADED )
   set( _linker_lang CXX )
  elseif( CMAKE_C_COMPILER_LOADED )
   set( _linker_lang C )
  elseif( CMAKE_Fortran_COMPILER_LOADED )
   set( _linker_lang Fortran )
  endif()

  set( RPATH_FLAG ${CMAKE_SHARED_LIBRARY_RUNTIME_${_linker_lang}_FLAG} )

  set( PKGCONFIG_MOD_FLAG ${CMAKE_Fortran_MODPATH_FLAG} )

  if( NOT PKGCONFIG_MOD_FLAG )
    set( PKGCONFIG_MOD_FLAG "-I" )
  endif()

  ecbuild_pkgconfig_libs( PKGCONFIG_LIBS LIBRARIES _PAR_IGNORE_LIBRARIES )

  ecbuild_library_dependencies( _libraries LIBRARIES )

  ecbuild_pkgconfig_libs( PKGCONFIG_LIBS_PRIVATE _libraries _PAR_IGNORE_LIBRARIES )

  if( NOT _PAR_NO_PRIVATE_INCLUDE_DIRS )
    ecbuild_include_dependencies( _include_dirs LIBRARIES )
    ecbuild_pkgconfig_include( PKGCONFIG_CFLAGS _include_dirs _PAR_IGNORE_INCLUDE_DIRS )
  endif()

  set( PKGCONFIG_INCLUDE "-I\${includedir}" )
  if( PKGCONFIG_HAVE_Fortran )
    set( PKGCONFIG_INCLUDE "${PKGCONFIG_INCLUDE} ${PKGCONFIG_MOD_FLAG}\${fmoddir}" )
  endif()

  if( NOT _PAR_TEMPLATE )
    set( _PAR_TEMPLATE "${ECBUILD_MACROS_DIR}/pkg-config.pc.in" )
  endif()

  set( PKGCONFIG_NAME ${LNAME} )
  if( _PAR_NAME )
    set( PKGCONFIG_NAME ${_PAR_NAME} )
  endif()

  if( NOT _PAR_FILENAME )
    set( _PAR_FILENAME "${PKGCONFIG_NAME}.pc" )
  endif()

  if( DEFINED ${PROJECT_NAME}_DESCRIPTION )
    set( PKGCONFIG_DESCRIPTION ${${PROJECT_NAME}_DESCRIPTION} )
  elseif( DEFINED ${PNAME}_DESCRIPTION )
    if(ECBUILD_2_COMPAT)
      if(ECBUILD_2_COMPAT_DEPRECATE AND NOT _PAR_DESCRIPTION)
        ecbuild_deprecate("${PNAME}_DESCRIPTION is deprecated. Please set ${PROJECT_NAME}_DESCRIPTION.")
      endif()
      set( PKGCONFIG_DESCRIPTION ${${PNAME}_DESCRIPTION} )
    endif()
  endif()
  if( _PAR_DESCRIPTION )
    set( PKGCONFIG_DESCRIPTION ${_PAR_DESCRIPTION} )
  endif()

  if( DEFINED ${PROJECT_NAME}_URL )
    set( PKGCONFIG_URL ${${PROJECT_NAME}_URL} )
  elseif( DEFINED ${PNAME}_URL )
    if(ECBUILD_2_COMPAT)
      if(ECBUILD_2_COMPAT_DEPRECATE AND NOT _PAR_URL)
        ecbuild_deprecate("${PNAME}_URL is deprecated. Please set ${PROJECT_NAME}_URL.")
      endif()
      set( PKGCONFIG_URL ${${PNAME}_URL} )
    endif()
  endif()
  if( _PAR_URL )
    set( PKGCONFIG_URL ${_PAR_URL} )
  endif()

  set( PKGCONFIG_VERSION ${${PROJECT_NAME}_VERSION} )
  set( PKGCONFIG_GIT_TAG ${${PROJECT_NAME}_GIT_SHA1} )  # For now set it to a commit id

  if( _PAR_VARIABLES )
    set( PKGCONFIG_VARIABLES "\n### Features:\n\n")
    foreach( _var ${_PAR_VARIABLES} )
      set( PKGCONFIG_VARIABLES "${PKGCONFIG_VARIABLES}${_var}=${${_var}}\n" )
    endforeach()
  endif()

  set( PKGCONFIG_DIR ${CMAKE_BINARY_DIR}/lib/pkgconfig )
  ecbuild_configure_file(${_PAR_TEMPLATE} ${CMAKE_CURRENT_BINARY_DIR}/${_PAR_FILENAME}.tmp @ONLY)

  # Reprocess the generated file to make it relocatable
  configure_file(${ECBUILD_MACROS_DIR}/pkg-config.cmake.in  ${CMAKE_CURRENT_BINARY_DIR}/${_PAR_FILENAME}-pkg-config-build.cmake @ONLY ESCAPE_QUOTES )
  add_custom_target(${_PAR_FILENAME}-pkg-config ALL
    BYPRODUCTS ${PKGCONFIG_DIR}/${_PAR_FILENAME}
    COMMAND ${CMAKE_COMMAND} -P ${PROJECT_BINARY_DIR}/${_PAR_FILENAME}-pkg-config-build.cmake
    DEPENDS 
      ${CMAKE_CURRENT_BINARY_DIR}/${_PAR_FILENAME}-pkg-config-build.cmake
  )

  install( FILES ${PKGCONFIG_DIR}/${_PAR_FILENAME} DESTINATION ${INSTALL_LIB_DIR}/pkgconfig )

  ecbuild_info( "pkg-config file to be created during build: ${_PAR_FILENAME}" )
endif()
endfunction(ecbuild_pkgconfig)
