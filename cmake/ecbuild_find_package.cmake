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
# ecbuild_find_package
# ====================
#
# Find a package and import its configuration. ::
#
#   ecbuild_find_package( [ NAME ] <name>
#                         [ [ VERSION ] <version> [ EXACT ] ]
#                         [ COMPONENTS <component1> [ <component2> ... ] ]
#                         [ URL <url> ]
#                         [ DESCRIPTION <description> ]
#                         [ TYPE <type> ]
#                         [ PURPOSE <purpose> ]
#                         [ FAILURE_MSG <message> ]
#                         [ REQUIRED ]
#                         [ QUIET ] )
#
# Options
# -------
#
# NAME : required
#   package name (used as ``Find<name>.cmake`` and ``<name>-config.cmake``)
#
# VERSION : optional
#   minimum required package version
#
# COMPONENTS : optional
#   list of package components to find (behaviour depends on the package)
#
# EXACT : optional, requires VERSION
#   require the exact version rather than a minimum version
#
# URL : optional
#   homepage of the package (shown in summary and stored in the cache)
#
# DESCRIPTION : optional
#   literal string or name of CMake variable describing the package
#
# TYPE : optional, one of RUNTIME|OPTIONAL|RECOMMENDED|REQUIRED
#   type of dependency of the project on this package (defaults to OPTIONAL)
#
# PURPOSE : optional
#   literal string or name of CMake variable describing which functionality
#   this package enables in the project
#
# FAILURE_MSG : optional
#   literal string or name of CMake variable containing a message to be
#   appended to the failure message if the package is not found
#
# REQUIRED : optional (equivalent to TYPE REQUIRED, and overrides TYPE argument)
#   fail if package cannot be found
#
# QUIET : optional
#   do not output package information if found
#
# Input variables
# ---------------
#
# The following CMake variables influence the behaviour if set (``<name>`` is
# the package name as given, ``<NAME>`` is the capitalised version):
#
# :<name>_ROOT:       install prefix path of the package
# :<name>_PATH:       install prefix path of the package, prefer <name>_ROOT
# :<NAME>_PATH:       install prefix path of the package, prefer <name>_ROOT
# :<name>_DIR:        directory containing the ``<name>-config.cmake`` file
#                     (usually ``<install-prefix>/lib/cmake/<name>``), prefer <name>_ROOT
# :CMAKE_PREFIX_PATH: Specify this when most packages are installed in same prefix
#
# The environment variables ``<name>_ROOT``, ``<name>_PATH``, ``<NAME>_PATH``, ``<name>_DIR``
# are taken into account only if the corresponding CMake variables are unset.
#
# Note, some packages are found via ``Find<name>.cmake`` and may have their own mechanism of
# finding paths with other variables, e.g. ``<name>_HOME``. See the corresponing
# ``Find<name>.cmake`` file for datails, or use `cmake --help-module Find<name>` if it is a
# standard CMake-recognized module.
#
# Usage
# -----
#
# The search proceeds as follows:
#
# 1.  If <name> is a subproject of the top-level project, search for
#     ``<name>-config.cmake`` in ``<name>_BINARY_DIR``.
#
# 2.  If ``Find<name>.cmake`` exists in ``CMAKE_MODULE_PATH``, search using it.
#
# 3.  If any paths have been specified by the user via CMake or environment
#     variables as given above:
#
#     * search for ``<name>-config.cmake`` in those paths only
#     * fail if the package was not found in any of those paths
#     * Search paths are in order from high to low priority:
#        - ``<name>_DIR``
#        - ``<name>_ROOT``
#        - ``<name>_PATH``
#        - ``<NAME>_PATH``
#        - ``ENV{<name>_ROOT}``
#        - ``ENV{<name>_PATH}``
#        - ``ENV{<NAME>_PATH}``
#        - ``CMAKE_PREFIX_PATH``
#        - ``ENV{<name>_DIR}``
#        - ``ENV{CMAKE_PREFIX_PATH}``
#        - ``system paths``
#       See CMake documentation of ``find_package()`` for details on search
#
# 4.  Fail if the package was not found and is REQUIRED.
#
##############################################################################

macro( ecbuild_find_package )

  set( options REQUIRED RECOMMENDED QUIET EXACT )
  set( single_value_args NAME VERSION URL DESCRIPTION TYPE PURPOSE FAILURE_MSG )
  set( multi_value_args COMPONENTS )

  cmake_parse_arguments( _PAR "${options}" "${single_value_args}" "${multi_value_args}" ${ARGN} )

  if(_PAR_UNPARSED_ARGUMENTS)
    if( NOT _PAR_NAME )
      set( _PAR_NAME ${ARGV0} )
      list( REMOVE_ITEM _PAR_UNPARSED_ARGUMENTS ${ARGV0} )
      if( NOT _PAR_VERSION AND "${ARGV1}" MATCHES "^[0-9]+(\\.[0-9]+)*$" )
          set( _PAR_VERSION ${ARGV1} )
          list( REMOVE_ITEM _PAR_UNPARSED_ARGUMENTS ${ARGV1} )
      endif()
    endif()
  endif()
  if(_PAR_UNPARSED_ARGUMENTS)
    ecbuild_critical("Unknown keywords given to ecbuild_find_package(): \"${_PAR_UNPARSED_ARGUMENTS}\"")
  endif()

  if( NOT _PAR_NAME  )
    ecbuild_critical("The call to ecbuild_find_package() doesn't specify the NAME.")
  endif()

  if( _PAR_EXACT AND NOT _PAR_VERSION )
    ecbuild_critical("Call to ecbuild_find_package() requests EXACT but doesn't specify VERSION.")
  endif()

  if( _PAR_QUIET )
    set( _${_PAR_NAME}_find_quiet QUIET )
  endif()

  # If the package is required, set TYPE to REQUIRED
  # Due to shortcomings in CMake's argument parser, passing TYPE REQUIRED has no effect
  if( _PAR_REQUIRED )
    set( _PAR_TYPE REQUIRED )
  endif()

  # As mentioned in documentation above, the default TYPE is OPTIONAL
  if( NOT _PAR_TYPE )
    set( _PAR_TYPE OPTIONAL )
  endif()

  set( _${_PAR_NAME}_version "" )
  if( _PAR_VERSION )
    set( _${_PAR_NAME}_version ${_PAR_VERSION} )
    if( _PAR_EXACT )
      set( _${_PAR_NAME}_version ${_PAR_VERSION} EXACT )
    endif()
  endif()

  set( _${_PAR_NAME}_components "" )
  if( DEFINED _PAR_COMPONENTS )
    set( _${_PAR_NAME}_components COMPONENTS ${_PAR_COMPONENTS} )
  endif()


  if( ECBUILD_2_COMPAT )
    # Disable deprecation warnings until ecbuild_mark_compat, because "<PROJECT>_FOUND" may already have been
    #   marked with "ecbuild_mark_compat()" in a bundle.
    set( DISABLE_ECBUILD_DEPRECATION_WARNINGS_orig ${DISABLE_ECBUILD_DEPRECATION_WARNINGS} )
    set( DISABLE_ECBUILD_DEPRECATION_WARNINGS ON )
  endif()

  # cancel the effect of ecbuild_install_project setting <package>_FOUND in
  # compat mode (otherwise this means the <package>-config.cmake file may not
  # always be loaded, see ECBUILD-401)
  if( ECBUILD_2_COMPAT )
    unset( ${_PAR_NAME}_FOUND )
  endif()

  # if a project with the same name has been defined, try to use it

  if( ${_PAR_NAME}_BINARY_DIR )

    # 1) search using CONFIG mode -- try to locate a configuration file provided by the package (package-config.cmake)
    #    <package>_BINARY_DIR is defined by CMake when using project()

    if( NOT ${_PAR_NAME}_FOUND )
      ecbuild_debug("ecbuild_find_package(${_PAR_NAME}): find_package( ${_PAR_NAME} ${_${_PAR_NAME}_version} ${_${_PAR_NAME}_components} ${_${_PAR_NAME}_find_quiet} )\n"
                    "                                    using hints ${_PAR_NAME}_BINARY_DIR=${${_PAR_NAME}_BINARY_DIR}" )
      find_package( ${_PAR_NAME} ${_${_PAR_NAME}_version} ${_${_PAR_NAME}_components} ${_${_PAR_NAME}_find_quiet}
        NO_MODULE
        HINTS ${${_PAR_NAME}_BINARY_DIR}
        NO_DEFAULT_PATH )
    endif()

    if( NOT ${_PAR_NAME}_FOUND )
      if( ${_PAR_NAME}_CONSIDERED_VERSIONS )
        ecbuild_critical( "${_PAR_NAME} was found in the source tree but no suitable version (or component set) was found at '${${_PAR_NAME}_BINARY_DIR}'" )
      else()
        ecbuild_critical( "${_PAR_NAME} was found in the source tree but could not be loaded from '${${_PAR_NAME}_BINARY_DIR}'" )
      endif()
    endif()

  else()

    # If a Find<name>.cmake module is found, use MODULE keyword, otherwise, use CONFIG.
    # This makes the find_package error message much more consise.
    find_file( ${_PAR_NAME}_FindModule Find${_PAR_NAME}.cmake  PATHS ${CMAKE_MODULE_PATH} ${CMAKE_ROOT}/Modules NO_DEFAULT_PATH NO_CMAKE_FIND_ROOT_PATH)
    find_file( ${_PAR_NAME}_FindModule Find${_PAR_NAME}.cmake  PATHS ${CMAKE_MODULE_PATH} ${CMAKE_ROOT}/Modules )
    if( ${_PAR_NAME}_FindModule )
      set( _${_PAR_NAME}_mode MODULE )
    else()
      set( _${_PAR_NAME}_mode CONFIG )
    endif()

    # Read variables like <name>_PATH and <NAME>_PATH,
    # and make older versions (CMake < 3.12) forward compatible with <name>_ROOT
    ecbuild_find_package_search_hints( NAME ${_PAR_NAME} )

    # Disable search in package registry, and save to be restored after find_package()
    set( CMAKE_FIND_PACKAGE_NO_PACKAGE_REGISTRY_orig ${CMAKE_FIND_PACKAGE_NO_PACKAGE_REGISTRY} )
    set( CMAKE_FIND_PACKAGE_NO_PACKAGE_REGISTRY ON )

    # The actual find_package()
    ecbuild_debug ( "ecbuild_find_package(${_PAR_NAME}): find_package( ${_PAR_NAME} ${_${_PAR_NAME}_version} ${_${_PAR_NAME}_find_quiet} ${_${_PAR_NAME}_components} ${_${_PAR_NAME}_mode} )")
    find_package( ${_PAR_NAME} ${_${_PAR_NAME}_version} ${_${_PAR_NAME}_find_quiet} ${_${_PAR_NAME}_components} ${_${_PAR_NAME}_mode} )

    # Restore setting 
    set( CMAKE_FIND_PACKAGE_NO_PACKAGE_REGISTRY ${CMAKE_FIND_PACKAGE_NO_PACKAGE_REGISTRY_orig} )

  endif()


  string( TOUPPER ${_PAR_NAME} pkgUPPER )

  if(ECBUILD_2_COMPAT)
    ecbuild_declare_compat(${pkgUPPER}_FOUND ${_PAR_NAME}_FOUND)
  endif()

  if( ECBUILD_2_COMPAT )
    set( DISABLE_ECBUILD_DEPRECATION_WARNINGS ${DISABLE_ECBUILD_DEPRECATION_WARNINGS_orig} )
  endif()

  ### final messages

  if( ${_PAR_NAME}_FOUND )

    if( NOT _PAR_QUIET )
      if( ${_PAR_NAME}_DIR ) # Defined by find_package if found via CONFIG option
        ecbuild_info( "${PROJECT_NAME} FOUND ${_PAR_NAME}: ${${_PAR_NAME}_DIR} (found version \"${${_PAR_NAME}_VERSION}\")" )
      else()
        if( ${_PAR_NAME}_VERSION )
          ecbuild_info( "${PROJECT_NAME} FOUND ${_PAR_NAME} (found version \"${${_PAR_NAME}_VERSION}\")" )
        else()
          ecbuild_info( "${PROJECT_NAME} FOUND ${_PAR_NAME}" )
        endif()
      endif()
      foreach( var IN ITEMS INCLUDE_DIRS INCLUDE_DIR )
        if( ${_PAR_NAME}_${var} )
          ecbuild_info( "   ${_PAR_NAME}_${var} : [${${_PAR_NAME}_${var}}]" )
          break()
        endif()
        if( ${pkgUPPER}_${var} )
          ecbuild_info( "   ${pkgUPPER}_${var} : [${${pkgUPPER}_${var}}]" )
          break()
        endif()
      endforeach()
      foreach( var IN ITEMS LIBRARIES LIBRARY )
        if( ${pkgUPPER}_${var} )
          ecbuild_info( "   ${pkgUPPER}_${var} : [${${pkgUPPER}_${var}}]" )
          break()
        endif()
        if( ${_PAR_NAME}_${var} )
          ecbuild_info( "   ${_PAR_NAME}_${var} : [${${_PAR_NAME}_${var}}]" )
          break()
        endif()
      endforeach()
      foreach( var IN ITEMS DEFINITIONS )
        if( ${pkgUPPER}_${var} )
          ecbuild_info( "   ${pkgUPPER}_${var} : [${${pkgUPPER}_${var}}]" )
          break()
        endif()
        if( ${_PAR_NAME}_${var} )
          ecbuild_info( "   ${_PAR_NAME}_${var} : [${${_PAR_NAME}_${var}}]" )
          break()
        endif()
      endforeach()
    endif()

    if( DEFINED ${_PAR_DESCRIPTION} )
      set( _PAR_DESCRIPTION ${${_PAR_DESCRIPTION}} )
    endif()
    if( DEFINED ${_PAR_PURPOSE} )
      set( _PAR_PURPOSE ${${_PAR_PURPOSE}} )
    endif()
    set_package_properties( ${_PAR_NAME} PROPERTIES
                            URL "${_PAR_URL}"
                            DESCRIPTION "${_PAR_DESCRIPTION}"
                            TYPE "${_PAR_TYPE}"
                            PURPOSE "${_PAR_PURPOSE}" )

  else()

    set( _failed_message ${_PAR_FAILURE_MSG} )
    if( DEFINED ${_PAR_FAILURE_MSG} )
      set( _failed_message "${${_PAR_FAILURE_MSG}}" )
    endif()
    # Quite verbose message, only to be printed when package is REQUIRED, or ECBUILD_LOG_LEVEL <= DEBUG
    # When TYPE is RECOMMENDED, we will issue with ecbuild_warn, otherwise ecbuild_info
    set( _default_failed_message "${PROJECT_NAME} FAILED to find ${_PAR_TYPE} package ${_PAR_NAME}" )
    if( ${_PAR_NAME}_FindModule )
      set( _failed_help "find_package(${_PAR_NAME}) used a Find${_PAR_NAME} module to find ${_PAR_NAME}\n"
      "  Please check file `${${_PAR_NAME}_FindModule}` for help on setting variables to find this package." )
    else()
      set( _failed_help "find_package(${_PAR_NAME}) assumed ${_PAR_NAME} is a CMake project.\n"
        "  Recommended variables that can help detection:\n"
        "    - ${_PAR_NAME}_ROOT : the install prefix (as in <prefix>/bin <prefix>/lib <prefix>/include)\n"
        "    - CMAKE_PREFIX_PATH : the install prefix (as ${_PAR_NAME}_ROOT, or its parent directory as in <prefix>/${_PAR_NAME})"
      )
    endif()
    if( NOT _failed_message )
      if(_PAR_TYPE MATCHES "(RECOMMENDED|REQUIRED)" )
        set( _failed_message "${_default_failed_message}\n${_failed_help}" )
      else()
        set( _failed_message ${_default_failed_message} )
      endif()
    endif()
    if( _PAR_REQUIRED )
      ecbuild_critical( "${_failed_message}" )
    endif()
    if( NOT _PAR_QUIET )
      if( _PAR_TYPE MATCHES "RECOMMENDED" )
        ecbuild_warn( "${_failed_message}" )
      else()
        ecbuild_info( "${_failed_message}" )
      endif()
      if( ECBUILD_LOG_LEVEL LESS_EQUAL ${ECBUILD_DEBUG} )
        ecbuild_debug( "${_failed_help}" )
      endif()
    else()
      ecbuild_debug( "${_failed_message}" )
    endif()

  endif()

endmacro()
